# RadioSubtitles::_suggest_for_move Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 201–228)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _suggest_for_move(state: Dictionary, last_token: String) -> Array[String]
```

## Description

Contextual suggestions for MOVE command

## Source

```gdscript
func _suggest_for_move(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	var tables := _tables
	var directions: Dictionary = tables.get("directions", {})

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
```
