# AntiTank::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/AntiTank.gd` (lines 16–22)</br>
*Belongs to:* [AntiTank](../../AntiTank.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(60, 132), Vector2(100, 30)], [Vector2(140, 132), Vector2(100, 30)]]
	}
```
