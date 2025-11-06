# EngineerController::unregister_unit Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 54–63)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

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
	_engineer_units.erase(unit_id)

	for i in range(_active_tasks.size() - 1, -1, -1):
		if _active_tasks[i].unit_id == unit_id:
			_active_tasks.remove_at(i)
```
