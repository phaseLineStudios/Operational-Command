# UnitSelect::_reset_resupply_pending Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 734–779)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _reset_resupply_pending(unit: UnitData) -> void
```

## Description

Reset pending resupply changes to original values (undo all changes including commits)

## Source

```gdscript
func _reset_resupply_pending(unit: UnitData) -> void:
	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	# Check if we have original state for this unit
	if not _original_equipment.has(unit.id):
		LogService.warn("No original state captured for unit %s" % unit.id, "UnitSelect")
		return

	# Get this unit's original state
	var original_eq: int = int(_original_equipment.get(unit.id, 0))
	var original_ammo_dict: Dictionary = _original_ammo.get(unit.id, {})
	var original_eq_pool: int = int(_original_equipment_pool.get(unit.id, 0))
	var original_ammo_pool_dict: Dictionary = _original_ammo_pools.get(unit.id, {})

	# Restore scenario unit to original state
	scenario_unit.state_equipment = float(original_eq) / 100.0
	for ammo_type in original_ammo_dict.keys():
		scenario_unit.state_ammunition[ammo_type] = original_ammo_dict[ammo_type]

	# Restore pools to original state
	_current_equipment_pool = original_eq_pool
	_current_ammo_pools = original_ammo_pool_dict.duplicate()
	Game.current_scenario.equipment_pool = original_eq_pool
	Game.current_scenario.ammo_pools = original_ammo_pool_dict.duplicate()

	# Reset pending values to original values
	_pending_equipment = original_eq
	_pending_ammo = original_ammo_dict.duplicate()

	LogService.info(
		(
			"Reset resupply to original for %s: equipment=%d%%, pool=%d"
			% [unit.id, original_eq, original_eq_pool]
		),
		"UnitSelect"
	)

	# Refresh UI to show original state
	_populate_supply_ui(unit, false)
```
