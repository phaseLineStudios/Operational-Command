# EngineerController::get_available_engineer_ammo Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 80–96)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func get_available_engineer_ammo(unit_id: String) -> Array[String]
```

## Description

Get available engineer ammunition types for a unit

## Source

```gdscript
func get_available_engineer_ammo(unit_id: String) -> Array[String]:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		return []

	var types: Array[String] = []

	if su.state_ammunition.get("ENGINEER_MINE", 0) > 0:
		types.append("ENGINEER_MINE")
	if su.state_ammunition.get("ENGINEER_DEMO", 0) > 0:
		types.append("ENGINEER_DEMO")
	if su.state_ammunition.get("ENGINEER_BRIDGE", 0) > 0:
		types.append("ENGINEER_BRIDGE")

	return types
```
