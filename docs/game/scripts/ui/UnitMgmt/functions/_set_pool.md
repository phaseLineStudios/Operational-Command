# UnitMgmt::_set_pool Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 98–102)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _set_pool(v: int) -> void
```

## Description

Write the replacement pool to Game scenario.

## Source

```gdscript
func _set_pool(v: int) -> void:
	if Game and Game.current_scenario:
		Game.current_scenario.replacement_pool = v
```
