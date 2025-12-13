# EngineerController::register_unit Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 47–52)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func register_unit(unit_id: String, su: ScenarioUnit) -> void
```

- **unit_id**: The ScenarioUnit ID (with SLOT suffix if applicable).
- **su**: The ScenarioUnit to register.

## Description

Register a unit and check if it's engineer-capable.

## Source

```gdscript
func register_unit(unit_id: String, su: ScenarioUnit) -> void:
	_units[unit_id] = su
	var is_eng: bool = _is_engineer_unit(su)
	_engineer_units[unit_id] = is_eng
```
