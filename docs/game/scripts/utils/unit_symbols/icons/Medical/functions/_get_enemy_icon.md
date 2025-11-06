# Medical::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Medical.gd` (lines 16–22)</br>
*Belongs to:* [Medical](../../Medical.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(28, 100), Vector2(172, 100)], [Vector2(100, 28), Vector2(100, 172)]]
	}
```
