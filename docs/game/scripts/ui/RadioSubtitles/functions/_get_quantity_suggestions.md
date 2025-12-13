# RadioSubtitles::_get_quantity_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 359–363)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_quantity_suggestions() -> Array[String]
```

## Description

Get quantity suggestions (numbers and units)

## Source

```gdscript
func _get_quantity_suggestions() -> Array[String]:
	var suggestions: Array[String] = ["100", "200", "500", "1000", "Meters", "Kilometers"]
	return suggestions
```
