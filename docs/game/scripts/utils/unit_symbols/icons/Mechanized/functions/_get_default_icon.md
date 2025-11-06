# Mechanized::_get_default_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Mechanized.gd` (lines 27–33)</br>
*Belongs to:* [Mechanized](../../Mechanized.md)

**Signature**

```gdscript
func _get_default_icon() -> Dictionary
```

## Source

```gdscript
func _get_default_icon() -> Dictionary:
	return {
		"type": "mixed",
		"shapes":
		[{"shape": "rect", "rect": Rect2(60, 79, 82, 44), "corner_radius": 19.5, "filled": false}],
		"paths": [[Vector2(45, 45), Vector2(155, 155)], [Vector2(155, 45), Vector2(45, 155)]]
	}
```
