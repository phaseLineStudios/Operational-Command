# EngineerController::_is_engineer_unit Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 429–439)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _is_engineer_unit(su: ScenarioUnit) -> bool
```

## Description

Check if unit has engineer ammunition

## Source

```gdscript
func _is_engineer_unit(su: ScenarioUnit) -> bool:
	if su.state_ammunition.get("ENGINEER_MINE", 0) > 0:
		return true
	if su.state_ammunition.get("ENGINEER_DEMO", 0) > 0:
		return true
	if su.state_ammunition.get("ENGINEER_BRIDGE", 0) > 0:
		return true

	return false
```
