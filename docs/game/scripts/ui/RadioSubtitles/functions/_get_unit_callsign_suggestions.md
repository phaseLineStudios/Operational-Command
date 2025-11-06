# RadioSubtitles::_get_unit_callsign_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 334–342)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_unit_callsign_suggestions() -> Array[String]
```

## Description

Get unit callsign suggestions (for targeting)

## Source

```gdscript
func _get_unit_callsign_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	for callsign in _unit_callsigns:
		var normalized := callsign.strip_edges().capitalize()
		if normalized != "":
			suggestions.append(normalized)
	return suggestions
```
