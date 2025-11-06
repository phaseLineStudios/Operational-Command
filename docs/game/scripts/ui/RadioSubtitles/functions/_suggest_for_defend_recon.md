# RadioSubtitles::_suggest_for_defend_recon Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 216–231)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _suggest_for_defend_recon(state: Dictionary, last_token: String) -> Array[String]
```

## Description

Contextual suggestions for DEFEND/RECON commands

## Source

```gdscript
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
```
