# ArtilleryController::is_artillery_unit Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 140–143)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func is_artillery_unit(unit_id: String) -> bool
```

## Description

Check if a unit is artillery-capable

## Source

```gdscript
func is_artillery_unit(unit_id: String) -> bool:
	return _artillery_units.get(unit_id, false)
```
