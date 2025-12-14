# RadioSubtitles::_suggest_for_fire Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 230–256)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _suggest_for_fire(state: Dictionary, last_token: String) -> Array[String]
```

## Description

Contextual suggestions for FIRE command

## Source

```gdscript
func _suggest_for_fire(state: Dictionary, last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	var tables := _tables
	var directions: Dictionary = tables.get("directions", {})

	var last_is_direction := directions.has(last_token)
	var last_is_number := last_token.is_valid_int() or _is_number_word(last_token)
	var last_is_ammo_type := _is_ammo_type(last_token)

	if last_is_number:
		suggestions.append_array(["Meters", "Rounds"])
	elif last_is_direction:
		suggestions.append_array(["100", "200", "500", "1000"])
	elif last_is_ammo_type or state.direction == "":
		# After ammo type or at start, suggest directions and targets
		suggestions.append_array(_get_direction_suggestions())
		suggestions.append_array(_get_terrain_label_suggestions())
	else:
		# Suggest ammo types first
		var ammo_types_config = _suggestions_config.get("ammo_types", {})
		for ammo_type in ammo_types_config.keys():
			if ammo_type not in ["he", "illumination"]:  # Skip duplicates
				suggestions.append(str(ammo_type).to_upper())

	return suggestions
```
