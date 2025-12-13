# RadioSubtitles::_generate_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 158–199)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _generate_suggestions(tokens: PackedStringArray) -> Array[String]
```

## Description

Generate suggestions based on current token state

## Source

```gdscript
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
```
