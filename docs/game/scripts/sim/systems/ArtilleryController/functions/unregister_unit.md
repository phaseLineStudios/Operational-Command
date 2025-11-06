# ArtilleryController::unregister_unit Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 85–94)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func unregister_unit(unit_id: String) -> void
```

## Description

Unregister a unit

## Source

```gdscript
func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_artillery_units.erase(unit_id)
	# Cancel any active missions from this unit
	for i in range(_active_missions.size() - 1, -1, -1):
		if _active_missions[i].unit_id == unit_id:
			_active_missions.remove_at(i)
```
