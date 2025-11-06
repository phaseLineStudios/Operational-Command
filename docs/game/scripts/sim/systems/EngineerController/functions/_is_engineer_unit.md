# EngineerController::_is_engineer_unit Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 429–439)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _is_engineer_unit(u: UnitData) -> bool
```

## Description

Check if unit has engineer ammunition

## Source

```gdscript
func _is_engineer_unit(u: UnitData) -> bool:
	if u.state_ammunition.get("ENGINEER_MINE", 0) > 0:
		return true
	if u.state_ammunition.get("ENGINEER_DEMO", 0) > 0:
		return true
	if u.state_ammunition.get("ENGINEER_BRIDGE", 0) > 0:
		return true

	return false
```
