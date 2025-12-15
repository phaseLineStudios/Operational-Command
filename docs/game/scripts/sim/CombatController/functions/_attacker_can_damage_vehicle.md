# CombatController::_attacker_can_damage_vehicle Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 544–551)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _attacker_can_damage_vehicle(attacker: ScenarioUnit) -> bool
```

## Description

Returns true when the attacker has the means to harm armored vehicles.

## Source

```gdscript
func _attacker_can_damage_vehicle(attacker: ScenarioUnit) -> bool:
	if attacker == null or attacker.unit == null:
		return false
	if attacker.unit.has_method("has_anti_vehicle_weapons"):
		return attacker.unit.has_anti_vehicle_weapons()
	return false
```
