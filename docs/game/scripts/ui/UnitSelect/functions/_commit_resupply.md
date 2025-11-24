# UnitSelect::_commit_resupply Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 685–732)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _commit_resupply(unit: UnitData) -> void
```

## Description

Commit pending resupply changes

## Source

```gdscript
func _commit_resupply(unit: UnitData) -> void:
	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	var current_equipment_pct := int(scenario_unit.state_equipment * 100.0)
	var equipment_cost := _pending_equipment - current_equipment_pct

	# Apply equipment resupply
	if equipment_cost > 0:
		if _current_equipment_pool >= equipment_cost:
			_current_equipment_pool -= equipment_cost
			scenario_unit.state_equipment = clamp(float(_pending_equipment) / 100.0, 0.0, 1.0)
			Game.current_scenario.equipment_pool = _current_equipment_pool
			LogService.info(
				"Committed equipment resupply for %s: %d%%" % [unit.id, _pending_equipment],
				"UnitSelect"
			)

	# Apply ammo resupply
	for ammo_type in _pending_ammo.keys():
		var target := int(_pending_ammo[ammo_type])
		var current := int(scenario_unit.state_ammunition.get(ammo_type, 0))
		var needed := target - current

		if needed > 0:
			var pool_available := int(_current_ammo_pools.get(ammo_type, 0))
			if pool_available >= needed:
				_current_ammo_pools[ammo_type] = pool_available - needed
				scenario_unit.state_ammunition[ammo_type] = target
				LogService.info(
					(
						"Committed ammo resupply for %s %s: +%d (now %d)"
						% [unit.id, ammo_type, needed, target]
					),
					"UnitSelect"
				)

	# Update scenario ammo pools
	Game.current_scenario.ammo_pools = _current_ammo_pools.duplicate()

	# Refresh the UI with the new committed values
	_populate_supply_ui(unit, true)
```
