class_name OrdersParser
extends Node
## Converts radio transcripts into structured orders.
##
## Consumes the full `result` string from STTService and extracts one or more
## machine-readable orders for AI units using tables from `NaRules`.
## @experimental

## Emitted when parsing succeeds.
signal parsed(orders: Array)
## Emitted if parsing fails (no orders, or malformed input).
signal parse_error(msg: String)

## High-level order categories.
## [br]CUSTOM is used for mission-specific commands registered via [method register_custom_command].
enum OrderType { MOVE, HOLD, ATTACK, DEFEND, RECON, FIRE, REPORT, CANCEL, CUSTOM, UNKNOWN }

## Minimal schema returned per order.
const ORDER_KEYS := {
	"callsign": "",
	"type": OrderType.UNKNOWN,
	"direction": "",
	"quantity": 0,
	"zone": "",
	"target_callsign": "",
	"direct": false,
	"ammo_type": "",  # For FIRE orders: "ap", "smoke", "illum"
	"rounds": 1,  # For FIRE orders: number of rounds
	"raw": []
}

var _tables: Dictionary
var _custom_commands: Dictionary = {}


func _ready() -> void:
	_tables = NARules.get_parser_tables()


## Register a custom command keyword for this mission.
## When the keyword is detected in voice input, generates a
## CUSTOM order instead of standard parsing.
## [br][br]
## [b]Called automatically by SimWorld._init_custom_commands() during mission init.[/b]
## [br][br]
## The generated order dictionary will contain:
## [br]- [code]type: OrderType.CUSTOM[/code]
## [br]- [code]custom_keyword: String[/code] - The matched keyword
## [br]- [code]custom_full_text: String[/code] - Full radio text
## [br]- [code]custom_metadata: Dictionary[/code] - Metadata passed here
## [br]- [code]raw: PackedStringArray[/code] - Tokenized input
## [param keyword] The keyword/phrase to match (e.g., "fire mission").
## Case-insensitive substring match.
## [param metadata] Optional metadata dict to attach to the CUSTOM order
## (e.g., trigger_id, route_as_order).
func register_custom_command(keyword: String, metadata: Dictionary = {}) -> void:
	var normalized := keyword.to_lower().strip_edges()
	if normalized != "":
		_custom_commands[normalized] = metadata
		LogService.info("Registered custom command: %s" % keyword, "OrdersParser.gd")


## Parse a full STT sentence into one or more structured orders.
func parse(text: String) -> Array:
	var tokens := _normalize_and_tokenize(text)
	if tokens.is_empty():
		emit_signal("parse_error", "No tokens.")
		return []

	# First check for custom commands (full text match)
	var normalized_text := text.to_lower().strip_edges()
	for keyword in _custom_commands.keys():
		if normalized_text.contains(keyword):
			var custom_order := _build_custom_order(keyword, normalized_text, tokens)
			emit_signal("parsed", [custom_order])
			LogService.info("Custom Order: %s" % keyword, "OrdersParser.gd")
			return [custom_order]

	# Fall back to standard order parsing
	var orders := _extract_orders(tokens)
	if orders.is_empty():
		emit_signal("parse_error", "No orders found.")
	else:
		emit_signal("parsed", orders)

		# Print hr orders for debugging
		for order in orders:
			LogService.info("Order: %s" % order_to_string(order), "OrdersParser.gd:41")
	return orders


## Scan tokens left→right and extract orders.
func _extract_orders(tokens: PackedStringArray) -> Array:
	var callsigns: Dictionary = _tables.get("callsigns", {})
	var actions: Dictionary = _tables.get("action_synonyms", {})
	var directions: Dictionary = _tables.get("directions", {})
	var stopwords: Dictionary = _tables.get("stopwords", {})
	var number_words: Dictionary = _tables.get("number_words", {})
	var prepositions: Dictionary = _tables.get("prepositions", {})
	var qty_labels: Dictionary = _tables.get("quantity_labels", {})

	var out: Array = []
	var cur := _new_order_builder()
	var i := 0

	while i < tokens.size():
		var t := tokens[i]

		# Skip artifacts/stopwords.
		if t == "[unk]" or stopwords.has(t):
			i += 1
			continue

		# Callsign.
		if callsigns.has(t):
			var cs := str(callsigns[t])
			if cur.callsign == "":
				cur.callsign = cs
			else:
				if cur.type != OrderType.UNKNOWN and cur.target_callsign == "":
					cur.target_callsign = cs
				else:
					if cur.callsign != "" and cur.type != OrderType.UNKNOWN:
						out.append(_finalize(cur))
					cur = _new_order_builder()
					cur.callsign = cs
			i += 1
			continue

		# Direct movement modifier (can come before or after move action)
		if t == "direct":
			cur.direct = true
			i += 1
			continue

		# Action keyword.
		if actions.has(t):
			var ot := int(actions[t])
			if cur.type != OrderType.UNKNOWN and cur.callsign != "":
				out.append(_finalize(cur))
				var prev_subject: String = cur.callsign
				cur = _new_order_builder()
				cur.callsign = prev_subject
			cur.type = ot

			# Detect report type if this is a REPORT order
			if ot == OrderType.REPORT:
				# Default to status
				cur.report_type = "status"
				# Look at next token to determine report type
				if i + 1 < tokens.size():
					var next := tokens[i + 1]
					if next in ["status"]:
						cur.report_type = "status"
						i += 1  # Skip the report type token
					elif next == "position":
						cur.report_type = "position"
						i += 1  # Skip the report type token
					elif next in ["contact", "contacts"]:
						cur.report_type = "contact"
						i += 1  # Skip the report type token
				# "sitrep" keyword defaults to status (already set)

			# Detect ammo type and rounds if this is a FIRE order
			if ot == OrderType.FIRE:
				# Default ammo type is AP
				cur.ammo_type = "ap"
				cur.rounds = 1
				# Scan ahead for ammo type and rounds keywords
				# But stop early if we hit grid/position keywords
				var j := i + 1
				while j < tokens.size():
					var next := tokens[j]
					# Stop IMMEDIATELY if we hit grid/position keywords
					# (don't consume them, let normal parsing handle them)
					if qty_labels.has(next) or directions.has(next):
						break
					# Detect ammo type
					if next in ["ap", "he", "frag", "antipersonnel"]:
						cur.ammo_type = "ap"
						j += 1
						continue
					elif next in ["smoke"]:
						cur.ammo_type = "smoke"
						j += 1
						continue
					elif next in ["illum", "illumination", "flare", "flares"]:
						cur.ammo_type = "illum"
						j += 1
						continue
					# Detect rounds count
					elif next in ["round", "rounds"]:
						# Look for number before "round/rounds"
						if j > i + 1:
							var prev := tokens[j - 1]
							if _is_int_literal(prev):
								cur.rounds = int(prev)
							elif number_words.has(prev):
								cur.rounds = int(number_words[prev])
						j += 1
						continue
					# Stop if we hit callsigns or other actions
					elif callsigns.has(next) or actions.has(next):
						break
					# Otherwise skip this token
					j += 1
				# Don't update i - let normal parsing handle position/grid
				# Only the ammo type scanning consumes its own tokens

			i += 1
			continue

		# Direction.
		if directions.has(t):
			cur.direction = str(directions[t])
			i += 1
			continue

		if qty_labels.has(t):
			var num_after := _read_number(tokens, i + 1, number_words)
			if num_after.consumed > 0:
				cur.zone = str(qty_labels[t])
				cur.quantity = num_after.value
				i += 1 + num_after.consumed
				continue
			# If no number after label, treat label as hint and continue scanning.
			i += 1
			continue

		var num_here := _read_number(tokens, i, number_words)
		if num_here.consumed > 0:
			i += num_here.consumed
			if i < tokens.size():
				var lbl := tokens[i]
				if qty_labels.has(lbl):
					cur.zone = str(qty_labels[lbl])
					i += 1
			cur.quantity = num_here.value
			continue

		# Prepositions are hints; skip.
		if prepositions.has(t):
			i += 1
			continue

		# Unknowns kept for debugging.
		cur.raw.append(t)
		i += 1

	# Flush tail if meaningful.
	if (
		cur.callsign != ""
		and (
			cur.type != OrderType.UNKNOWN
			or cur.direction != ""
			or cur.quantity != 0
			or cur.target_callsign != ""
		)
	):
		out.append(_finalize(cur))

	return out


## Builder for a fresh order dictionary.
func _new_order_builder() -> Dictionary:
	return {
		"callsign": "",
		"type": OrderType.UNKNOWN,
		"direction": "",
		"quantity": 0,
		"zone": "",
		"target_callsign": "",
		"direct": false,
		"report_type": "",  # For REPORT orders: status, position, contact
		"ammo_type": "",  # For FIRE orders: "ap", "smoke", "illum"
		"rounds": 1,  # For FIRE orders: number of rounds
		"raw": PackedStringArray()
	}


## Finalize a builder into an immutable order dictionary.
func _finalize(cur: Dictionary) -> Dictionary:
	if cur.type == OrderType.UNKNOWN and cur.direction != "":
		cur.type = OrderType.MOVE
	if cur.type == OrderType.CANCEL and cur.callsign == "":
		return {}
	return {
		"callsign": str(cur.callsign),
		"type": int(cur.type),
		"direction": str(cur.direction),
		"quantity": int(cur.quantity),
		"zone": str(cur.zone),
		"target_callsign": str(cur.target_callsign),
		"direct": bool(cur.get("direct", false)),
		"report_type": str(cur.report_type),
		"ammo_type": str(cur.ammo_type),
		"rounds": int(cur.rounds),
		"raw": (cur.raw as PackedStringArray).duplicate()
	}


## Lowercase, strip, keep letters/digits/space/hyphen/brackets, and split.
func _normalize_and_tokenize(text: String) -> PackedStringArray:
	var s := text.to_lower().strip_edges()
	s = s.replace("—", "-").replace("–", "-")
	var cleaned := ""
	for i in s.length():
		var cp := s.unicode_at(i)
		if (
			_is_ascii_alpha_cp(cp)
			or _is_ascii_digit_cp(cp)
			or cp == 32
			or cp == 45
			or cp == 91
			or cp == 93
		):
			cleaned += char(cp)

	# Collapse spaces and split.
	cleaned = cleaned.strip_edges()
	var parts := cleaned.split(" ", false)
	var out := PackedStringArray()
	for p in parts:
		if p.length() > 0:
			out.append(p)
	return out


## Read a verbal or digit number from tokens[idx..]; sets 'consumed'.
func _read_number(tokens: PackedStringArray, idx: int, number_words: Dictionary) -> Dictionary:
	var nil := {"value": 0, "consumed": 0}

	if idx >= tokens.size():
		return nil

	if _is_int_literal(tokens[idx]):
		@warning_ignore("confusable_local_declaration")
		var j := idx
		var digits := ""
		while j < tokens.size() and _is_int_literal(tokens[j]):
			digits += tokens[j]  # concat tokens
			j += 1
		return {"value": int(digits), "consumed": j - idx}

	var vals: Array = []
	var j := idx
	while j < tokens.size():
		var t := tokens[j]
		if not number_words.has(t):
			break
		vals.append(int(number_words[t]))
		j += 1

	if vals.is_empty():
		return nil

	var all_under_ten := true
	for v in vals:
		var iv := int(v)
		if iv < 0 or iv > 9:
			all_under_ten = false
			break

	if all_under_ten and vals.size() >= 2:
		var v := 0
		for d in vals:
			v = v * 10 + int(d)
		return {"value": v, "consumed": vals.size()}

	var has_large := false
	for v in vals:
		if int(v) >= 100:
			has_large = true
			break

	if has_large:
		var acc := 0
		var current := 0
		for v in vals:
			var iv := int(v)
			if iv == 100 or iv == 1000:
				if current == 0:
					current = 1
				current *= iv
				acc += current
				current = 0
			else:
				current += iv
		return {"value": acc + current, "consumed": vals.size()}
	else:
		var sum := 0
		for v in vals:
			sum += int(v)
		return {"value": sum, "consumed": vals.size()}


## True if s consists only of ASCII digits (uses unicode_at()).
func _is_int_literal(s: String) -> bool:
	if s.length() == 0:
		return false
	for i in s.length():
		var cp := s.unicode_at(i)
		if not _is_ascii_digit_cp(cp):
			return false
	return true


## True if all numbers in array are 0..9.
func _all_under_ten(vals: Array) -> bool:
	for v in vals:
		var iv := int(v)
		if iv < 0 or iv > 9:
			return false
	return true


## ASCII alpha test for a code point.
func _is_ascii_alpha_cp(cp: int) -> bool:
	return (cp >= 65 and cp <= 90) or (cp >= 97 and cp <= 122)


## ASCII digit test for a code point.
func _is_ascii_digit_cp(cp: int) -> bool:
	return cp >= 48 and cp <= 57


## Human-friendly summary for a single order.
func order_to_string(o: Dictionary) -> String:
	if o.is_empty():
		return "<invalid>"
	var s := ""
	s += "%s: " % str(o.get("callsign", ""))
	s += _order_type_to_string(int(o.get("type", OrderType.UNKNOWN)))
	var dir := str(o.get("direction", ""))
	if dir != "":
		s += " " + dir
	var qty := int(o.get("quantity", 0))
	if qty > 0:
		var z := str(o.get("zone", ""))
		if z != "":
			s += " %d %s" % [qty, z]
		else:
			s += " %d" % qty
	var tgt := str(o.get("target_callsign", ""))
	if tgt != "":
		s += " -> %s" % tgt
	return s.strip_edges()


## Build a CUSTOM order from a matched keyword.
func _build_custom_order(
	keyword: String, full_text: String, tokens: PackedStringArray
) -> Dictionary:
	var metadata: Dictionary = _custom_commands.get(keyword, {})
	return {
		"callsign": "",
		"type": OrderType.CUSTOM,
		"direction": "",
		"quantity": 0,
		"zone": "",
		"target_callsign": "",
		"raw": tokens.duplicate(),
		"custom_keyword": keyword,
		"custom_full_text": full_text,
		"custom_metadata": metadata
	}


## String name for OrderType.
func _order_type_to_string(t: int) -> String:
	match t:
		OrderType.MOVE:
			return "MOVE"
		OrderType.HOLD:
			return "HOLD"
		OrderType.DEFEND:
			return "DEFEND"
		OrderType.ATTACK:
			return "ATTACK"
		OrderType.RECON:
			return "RECON"
		OrderType.FIRE:
			return "FIRE"
		OrderType.REPORT:
			return "REPORT"
		OrderType.CANCEL:
			return "CANCEL"
		OrderType.CUSTOM:
			return "CUSTOM"
		_:
			return "UNKNOWN"
