# OrdersParser::_extract_orders Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 94–296)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _extract_orders(tokens: PackedStringArray) -> Array
```

## Description

Scan tokens left→right and extract orders.

## Source

```gdscript
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

			# Detect engineer task type if this is an ENGINEER order
			if ot == OrderType.ENGINEER:
				# Default task type is mine
				cur.engineer_task = "mine"
				# Scan ahead for task type keywords
				var j := i + 1
				while j < tokens.size():
					var next := tokens[j]
					# Stop if we hit grid/position keywords
					if qty_labels.has(next) or directions.has(next):
						break
					# Detect task type
					if next in ["mine", "mines", "minefield"]:
						cur.engineer_task = "mine"
						j += 1
						continue
					elif next in ["demo", "demolition", "demolitions", "charge", "charges"]:
						cur.engineer_task = "demo"
						j += 1
						continue
					elif next in ["bridge", "bridges"]:
						cur.engineer_task = "bridge"
						j += 1
						continue
					# Stop if we hit callsigns or other actions
					elif callsigns.has(next) or actions.has(next):
						break
					# Otherwise skip this token
					j += 1
				# Don't update i - let normal parsing handle position/grid

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
```
