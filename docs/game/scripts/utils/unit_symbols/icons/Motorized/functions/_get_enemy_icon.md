# Motorized::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Motorized.gd` (lines 21–32)</br>
*Belongs to:* [Motorized](../../Motorized.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(64, 64), Vector2(136, 136)],
			[Vector2(64, 136), Vector2(136, 64)],
			[Vector2(100, 28), Vector2(100, 172)]
		]
	}
```
