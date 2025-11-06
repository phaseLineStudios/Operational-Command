# Mechanized::_get_friendly_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Mechanized.gd` (lines 9–17)</br>
*Belongs to:* [Mechanized](../../Mechanized.md)

**Signature**

```gdscript
func _get_friendly_icon() -> Dictionary
```

## Source

```gdscript
func _get_friendly_icon() -> Dictionary:
	return {
		"type": "mixed",
		"shapes":
		[{"shape": "rect", "rect": Rect2(60, 79, 82, 44), "corner_radius": 19.5, "filled": false}],
		"paths": [[Vector2(25, 50), Vector2(175, 150)], [Vector2(25, 150), Vector2(175, 50)]]
	}
```
