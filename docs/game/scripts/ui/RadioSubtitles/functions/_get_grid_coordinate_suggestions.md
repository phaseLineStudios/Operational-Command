# RadioSubtitles::_get_grid_coordinate_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 344–351)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_grid_coordinate_suggestions() -> Array[String]
```

## Description

Get grid coordinate suggestions (6 and 8 digit)

## Source

```gdscript
func _get_grid_coordinate_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	# Suggest some example grid formats
	suggestions.append_array(["123456", "234567", "345678"])  # 6-digit examples
	suggestions.append_array(["12345678", "23456789"])  # 8-digit examples
	return suggestions
```
