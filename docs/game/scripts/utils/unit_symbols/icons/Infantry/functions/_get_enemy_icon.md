# Infantry::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Infantry.gd` (lines 16–22)</br>
*Belongs to:* [Infantry](../../Infantry.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(64, 64), Vector2(136, 136)], [Vector2(64, 136), Vector2(136, 64)]]
	}
```
