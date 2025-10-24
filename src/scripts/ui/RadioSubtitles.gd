extends Control
## Displays radio subtitles and suggests valid next words based on current input.
##
## Shows partial speech recognition results and provides intelligent suggestions
## for completing valid radio commands using NARules tables.

## Display time for result text after PTT release (in seconds)
@export var result_display_time: float = 2.0
## Maximum number of suggestions to show
@export var max_suggestions: int = 8

@onready var _subtitle_label: Label = %SubtitleLabel
@onready var _suggestions_container: HBoxContainer = %SuggestionsContainer

var _tables: Dictionary = {}
var _hide_timer: Timer = null
var _current_text: String = ""
var _is_transmitting: bool = false
var _terrain_labels: Array[String] = []
var _unit_callsigns: Array[String] = []


func _ready() -> void:
	_tables = NARules.get_parser_tables()
	visible = false

	# Create hide timer
	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(_hide_timer)


## Show subtitle with current partial text
func show_partial(text: String) -> void:
	_current_text = text
	_is_transmitting = true
	visible = true
	_hide_timer.stop()
	_update_display()


## Show final result text
func show_result(text: String) -> void:
	_current_text = text
	_is_transmitting = false
	visible = true
	_update_display()

	# Auto-hide after delay
	_hide_timer.start(result_display_time)


## Hide the subtitle display
func hide_subtitles() -> void:
	visible = false
	_current_text = ""
	_is_transmitting = false


## Set terrain labels for suggestions
func set_terrain_labels(labels: Array[String]) -> void:
	_terrain_labels = labels


## Set unit callsigns for suggestions
func set_unit_callsigns(callsigns: Array[String]) -> void:
	_unit_callsigns = callsigns


## Update the display with current text and suggestions
func _update_display() -> void:
	if not _subtitle_label:
		return

	# Update subtitle text (convert number words to digits)
	var display_text := _convert_numbers_to_digits(_current_text)
	if _is_transmitting:
		display_text += " _"  # Show cursor while transmitting
	_subtitle_label.text = display_text

	# Update suggestions
	if _is_transmitting and _current_text != "":
		_update_suggestions()
	else:
		_clear_suggestions()


## Analyze current text and generate suggestions for next word
func _update_suggestions() -> void:
	if not _suggestions_container:
		return

	# Clear existing suggestions
	for child in _suggestions_container.get_children():
		child.queue_free()

	var tokens := _normalize_and_tokenize(_current_text)
	var suggestions := _generate_suggestions(tokens)

	# Create suggestion labels
	var count := 0
	for suggestion in suggestions:
		if count >= max_suggestions:
			break

		var label := Label.new()
		label.text = suggestion
		label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7, 0.8))
		_suggestions_container.add_child(label)
		count += 1


## Clear all suggestions
func _clear_suggestions() -> void:
	if not _suggestions_container:
		return

	for child in _suggestions_container.get_children():
		child.queue_free()


## Generate suggestions based on current token state
func _generate_suggestions(tokens: PackedStringArray) -> Array[String]:
	var suggestions: Array[String] = []

	if tokens.is_empty():
		# No input yet - suggest callsigns
		suggestions.append_array(_get_callsign_suggestions())
		return suggestions

	# Analyze what we have so far
	var state := _analyze_tokens(tokens)
	var last_token := tokens[tokens.size() - 1] if tokens.size() > 0 else ""

	# Suggest based on what's missing
	if state.callsign == "":
		# Need a callsign
		suggestions.append_array(_get_callsign_suggestions())
	elif state.type == OrdersParser.OrderType.UNKNOWN:
		# Have callsign, need action
		suggestions.append_array(_get_action_suggestions())
	else:
		# Have callsign and action - context-aware suggestions
		match state.type:
			OrdersParser.OrderType.MOVE:
				suggestions.append_array(_suggest_for_move(state, last_token))
			OrdersParser.OrderType.ATTACK:
				if state.target_callsign == "":
					suggestions.append_array(_get_unit_callsign_suggestions())
			OrdersParser.OrderType.FIRE:
				suggestions.append_array(_suggest_for_fire(state, last_token))
			OrdersParser.OrderType.DEFEND, OrdersParser.OrderType.RECON:
				suggestions.append_array(_suggest_for_defend_recon(state, last_token))
			OrdersParser.OrderType.REPORT:
				suggestions.append_array(_suggest_for_report(state, last_token))
			_:
				# Default suggestions
				if state.direction == "":
					suggestions.append_array(_get_direction_suggestions())
				suggestions.append_array(_get_terrain_label_suggestions())

	return _deduplicate(suggestions)


## Contextual suggestions for MOVE command
func _suggest_for_move(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	var tables := _tables
	var directions: Dictionary = tables.get("directions", {})
	var qty_labels: Dictionary = tables.get("quantity_labels", {})

	# Check what the last token was
	var last_is_direction := directions.has(last_token)
	var last_is_number := last_token.is_valid_int() or _is_number_word(last_token)
	var last_is_grid := last_token == "grid"

	if last_is_grid:
		# Just said "grid" - suggest grid coordinates
		suggestions.append_array(_get_grid_coordinate_suggestions())
	elif last_is_number:
		# Just said a number - suggest units
		suggestions.append_array(["Meters", "Kilometers"])
	elif last_is_direction:
		# Just said a direction - suggest numbers
		suggestions.append_array(["100", "200", "500", "1000", "1500", "2000"])
	elif state.direction == "" and state.quantity == 0 and not state.used_grid:
		# Haven't specified destination yet - suggest all options
		suggestions.append_array(_get_direction_suggestions())
		suggestions.append("Grid")
		suggestions.append_array(_get_terrain_label_suggestions())

	return suggestions


## Contextual suggestions for FIRE command
func _suggest_for_fire(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	var tables := _tables
	var directions: Dictionary = tables.get("directions", {})

	var last_is_direction := directions.has(last_token)
	var last_is_number := last_token.is_valid_int() or _is_number_word(last_token)

	if last_is_number:
		suggestions.append_array(["Meters", "Rounds"])
	elif last_is_direction:
		suggestions.append_array(["100", "200", "500", "1000"])
	elif state.direction == "":
		suggestions.append_array(_get_direction_suggestions())
		suggestions.append_array(_get_terrain_label_suggestions())

	return suggestions


## Contextual suggestions for DEFEND/RECON commands
func _suggest_for_defend_recon(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	var tables := _tables
	var directions: Dictionary = tables.get("directions", {})

	var last_is_direction := directions.has(last_token)

	if last_is_direction:
		suggestions.append_array(["100", "200", "500", "1000"])
	elif state.direction == "":
		suggestions.append_array(_get_direction_suggestions())
		suggestions.append_array(_get_terrain_label_suggestions())

	return suggestions


## Suggestions for REPORT command
func _suggest_for_report(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	# Suggest report types
	suggestions.append_array(["Status", "Contact", "Position", "Ammunition", "Casualties"])
	return suggestions


## Analyze tokens to determine current order state
func _analyze_tokens(tokens: PackedStringArray) -> Dictionary:
	var callsigns: Dictionary = _tables.get("callsigns", {})
	var actions: Dictionary = _tables.get("action_synonyms", {})
	var directions: Dictionary = _tables.get("directions", {})
	var stopwords: Dictionary = _tables.get("stopwords", {})
	var number_words: Dictionary = _tables.get("number_words", {})
	var qty_labels: Dictionary = _tables.get("quantity_labels", {})

	var state := {
		"callsign": "",
		"type": OrdersParser.OrderType.UNKNOWN,
		"direction": "",
		"quantity": 0,
		"target_callsign": "",
		"used_grid": false,
	}

	for t in tokens:
		if stopwords.has(t):
			continue

		if callsigns.has(t):
			if state.callsign == "":
				state.callsign = str(callsigns[t])
			elif state.type != OrdersParser.OrderType.UNKNOWN:
				state.target_callsign = str(callsigns[t])
		elif actions.has(t):
			state.type = int(actions[t])
		elif directions.has(t):
			state.direction = str(directions[t])
		elif t == "grid":
			state.used_grid = true
			state.quantity = 1  # Mark as having destination
		elif qty_labels.has(t):
			state.quantity = 1  # Mark that we have quantity context
		elif number_words.has(t) or t.is_valid_int():
			state.quantity = 1  # Mark that we have a number

	return state


## Get callsign suggestions
func _get_callsign_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	var callsigns: Dictionary = _tables.get("callsigns", {})
	for key in callsigns.keys():
		suggestions.append(str(key).capitalize())
	return suggestions


## Get action suggestions
func _get_action_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	var actions: Dictionary = _tables.get("action_synonyms", {})
	var seen := {}
	for key in actions.keys():
		var action_type: int = actions[key]
		if not seen.has(action_type):
			seen[action_type] = true
			suggestions.append(str(key).capitalize())
	return suggestions


## Get direction suggestions
func _get_direction_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	var directions: Dictionary = _tables.get("directions", {})
	var seen := {}
	for key in directions.keys():
		var dir: String = directions[key]
		if not seen.has(dir):
			seen[dir] = true
			suggestions.append(str(key).capitalize())
	return suggestions


## Get quantity suggestions (numbers and units)
func _get_quantity_suggestions() -> Array[String]:
	var suggestions: Array[String] = ["100", "200", "500", "1000", "Meters", "Kilometers"]
	return suggestions


## Get terrain label suggestions
func _get_terrain_label_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	for label in _terrain_labels:
		var normalized := label.strip_edges().capitalize()
		if normalized != "":
			suggestions.append(normalized)
	return suggestions


## Get unit callsign suggestions (for targeting)
func _get_unit_callsign_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	for callsign in _unit_callsigns:
		var normalized := callsign.strip_edges().capitalize()
		if normalized != "":
			suggestions.append(normalized)
	return suggestions


## Get grid coordinate suggestions (6 and 8 digit)
func _get_grid_coordinate_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	# Suggest some example grid formats
	suggestions.append_array(["123456", "234567", "345678"])  # 6-digit examples
	suggestions.append_array(["12345678", "23456789"])  # 8-digit examples
	return suggestions


## Check if a token is a number word
func _is_number_word(token: String) -> bool:
	var number_words: Dictionary = _tables.get("number_words", {})
	return number_words.has(token)


## Normalize and tokenize text (same as OrdersParser)
func _normalize_and_tokenize(text: String) -> PackedStringArray:
	var s := text.to_lower().strip_edges()
	s = s.replace("—", "-").replace("–", "-")
	var cleaned := ""
	for i in s.length():
		var cp := s.unicode_at(i)
		if _is_ascii_alpha_cp(cp) or _is_ascii_digit_cp(cp) or cp == 32 or cp == 45:
			cleaned += char(cp)

	cleaned = cleaned.strip_edges()
	var parts := cleaned.split(" ", false)
	var out := PackedStringArray()
	for p in parts:
		if p.length() > 0:
			out.append(p)
	return out


## ASCII alpha test
func _is_ascii_alpha_cp(cp: int) -> bool:
	return (cp >= 65 and cp <= 90) or (cp >= 97 and cp <= 122)


## ASCII digit test
func _is_ascii_digit_cp(cp: int) -> bool:
	return cp >= 48 and cp <= 57


## Deduplicate array
func _deduplicate(arr: Array[String]) -> Array[String]:
	var seen := {}
	var out: Array[String] = []
	for item in arr:
		if not seen.has(item):
			seen[item] = true
			out.append(item)
	return out


## Handle hide timer timeout
func _on_hide_timer_timeout() -> void:
	hide_subtitles()


## Convert number words to digits in text (e.g., "five hundred" -> "500")
func _convert_numbers_to_digits(text: String) -> String:
	var tokens := text.to_lower().split(" ", false)
	if tokens.is_empty():
		return text

	var number_words: Dictionary = _tables.get("number_words", {})
	var result_tokens: Array[String] = []
	var i := 0

	while i < tokens.size():
		var t := tokens[i]

		# Check if this token is a number word or already a digit
		if number_words.has(t) or _is_all_digits(t):
			# Try to read a complete number sequence
			var num_result := _read_number_sequence(tokens, i, number_words)
			if num_result.value > 0:
				result_tokens.append(str(num_result.value))
				i += num_result.consumed
				continue

		# Not a number, keep as-is
		result_tokens.append(t)
		i += 1

	return " ".join(result_tokens)


## Read a number sequence from tokens and return the value
func _read_number_sequence(tokens: Array, idx: int, number_words: Dictionary) -> Dictionary:
	var nil := {"value": 0, "consumed": 0}

	if idx >= tokens.size():
		return nil

	# Check if it's already a digit literal
	if _is_all_digits(tokens[idx]):
		var j := idx
		var digits := ""
		while j < tokens.size() and _is_all_digits(tokens[j]):
			digits += tokens[j]
			j += 1
		return {"value": int(digits), "consumed": j - idx}

	# Collect consecutive number words
	var vals: Array = []
	var j := idx
	while j < tokens.size():
		var t: String = tokens[j]
		if not number_words.has(t):
			break
		vals.append(int(number_words[t]))
		j += 1

	if vals.is_empty():
		return nil

	# Convert sequence to number
	var consumed := vals.size()

	# Check if all values are 0-9 (spoken digits)
	var all_under_ten := true
	for v in vals:
		if int(v) < 0 or int(v) > 9:
			all_under_ten = false
			break

	if all_under_ten and vals.size() >= 2:
		# Concatenate digits: "five four" -> 54
		var result := 0
		for d in vals:
			result = result * 10 + int(d)
		return {"value": result, "consumed": consumed}

	# Check for large numbers (hundred, thousand)
	var has_large := false
	for v in vals:
		if int(v) >= 100:
			has_large = true
			break

	if has_large:
		# Process compound numbers: "five hundred" -> 500, "two thousand" -> 2000
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
		return {"value": acc + current, "consumed": consumed}
	else:
		# Sum simple numbers: "twenty five" -> 25
		var sum := 0
		for v in vals:
			sum += int(v)
		return {"value": sum, "consumed": consumed}


## Check if string is all digits
func _is_all_digits(s: String) -> bool:
	if s.length() == 0:
		return false
	for i in s.length():
		var cp := s.unicode_at(i)
		if not _is_ascii_digit_cp(cp):
			return false
	return true
