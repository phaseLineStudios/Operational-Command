# UnitMgmt::_get_pool Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 91–96)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _get_pool() -> int
```

## Description

Read the replacement pool from Game scenario.

## Source

```gdscript
func _get_pool() -> int:
	if Game and Game.current_scenario:
		return int(Game.current_scenario.replacement_pool)
	return 0
```
