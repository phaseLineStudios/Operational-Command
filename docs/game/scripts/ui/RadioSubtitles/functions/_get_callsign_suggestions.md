# RadioSubtitles::_get_callsign_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 283–290)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_callsign_suggestions() -> Array[String]
```

## Description

Get callsign suggestions

## Source

```gdscript
func _get_callsign_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	var callsigns: Dictionary = _tables.get("callsigns", {})
	for key in callsigns.keys():
		suggestions.append(str(key).capitalize())
	return suggestions
```
