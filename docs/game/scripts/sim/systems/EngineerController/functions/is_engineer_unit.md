# EngineerController::is_engineer_unit Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 75–78)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func is_engineer_unit(unit_id: String) -> bool
```

## Description

Check if a unit is engineer-capable

## Source

```gdscript
func is_engineer_unit(unit_id: String) -> bool:
	return _engineer_units.get(unit_id, false)
```
