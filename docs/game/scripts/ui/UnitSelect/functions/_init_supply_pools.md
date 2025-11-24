# UnitSelect::_init_supply_pools Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 458–465)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _init_supply_pools() -> void
```

## Description

Initialize supply pools from scenario

## Source

```gdscript
func _init_supply_pools() -> void:
	if not Game.current_scenario:
		return

	_current_equipment_pool = Game.current_scenario.equipment_pool
	_current_ammo_pools = Game.current_scenario.ammo_pools.duplicate()
```
