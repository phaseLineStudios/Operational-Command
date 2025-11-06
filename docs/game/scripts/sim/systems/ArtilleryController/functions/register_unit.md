# ArtilleryController::register_unit Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 78–83)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func register_unit(unit_id: String, u: UnitData) -> void
```

- **unit_id**: The ScenarioUnit ID (with SLOT suffix if applicable).
- **u**: The UnitData to register.

## Description

Register a unit and check if it's artillery-capable.

## Source

```gdscript
func register_unit(unit_id: String, u: UnitData) -> void:
	_units[unit_id] = u
	var is_arty: bool = _is_artillery_unit(u)
	_artillery_units[unit_id] = is_arty
```
