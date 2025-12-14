# RadioSubtitles::_analyze_tokens Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 285–325)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _analyze_tokens(tokens: PackedStringArray) -> Dictionary
```

## Description

Analyze tokens to determine current order state

## Source

```gdscript
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
```
