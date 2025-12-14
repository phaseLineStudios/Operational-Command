# ArtilleryController::register_unit Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 102–107)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func register_unit(unit_id: String, su: ScenarioUnit) -> void
```

- **unit_id**: The ScenarioUnit ID (with SLOT suffix if applicable).
- **su**: The ScenarioUnit to register.

## Description

Register a unit and check if it's artillery-capable.

## Source

```gdscript
func register_unit(unit_id: String, su: ScenarioUnit) -> void:
	_units[unit_id] = su
	var is_arty: bool = _is_artillery_unit(su)
	_artillery_units[unit_id] = is_arty
```
