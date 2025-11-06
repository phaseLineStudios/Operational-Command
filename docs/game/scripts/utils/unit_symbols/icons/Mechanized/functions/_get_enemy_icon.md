# Mechanized::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Mechanized.gd` (lines 18–26)</br>
*Belongs to:* [Mechanized](../../Mechanized.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return {
		"type": "mixed",
		"shapes":
		[{"shape": "rect", "rect": Rect2(60, 79, 82, 44), "corner_radius": 19.5, "filled": false}],
		"paths": [[Vector2(64, 64), Vector2(136, 136)], [Vector2(64, 136), Vector2(136, 64)]]
	}
```
