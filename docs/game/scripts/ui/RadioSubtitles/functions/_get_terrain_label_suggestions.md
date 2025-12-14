# RadioSubtitles::_get_terrain_label_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 365–373)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_terrain_label_suggestions() -> Array[String]
```

## Description

Get terrain label suggestions

## Source

```gdscript
func _get_terrain_label_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	for label in _terrain_labels:
		var normalized := label.strip_edges().capitalize()
		if normalized != "":
			suggestions.append(normalized)
	return suggestions
```
