# RadioSubtitles::_get_direction_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 305–316)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_direction_suggestions() -> Array[String]
```

## Description

Get direction suggestions

## Source

```gdscript
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
```
