# CombatController::_is_vehicle_target Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 545–552)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _is_vehicle_target(defender: ScenarioUnit) -> bool
```

## Description

Returns true when the defender should be treated as a vehicle for damage resolution.

## Source

```gdscript
func _is_vehicle_target(defender: ScenarioUnit) -> bool:
	if defender == null or defender.unit == null:
		return false
	if defender.unit.has_method("is_vehicle_unit"):
		return defender.unit.is_vehicle_unit()
	return false
```
