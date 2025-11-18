# CombatController::_compute_dynamic_attack_power Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 483–502)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _compute_dynamic_attack_power(attacker: ScenarioUnit) -> float
```

## Description

Computes the effective attack value for an attacker using equipment + ammo state.

## Source

```gdscript
func _compute_dynamic_attack_power(attacker: ScenarioUnit) -> float:
	if attacker == null or attacker.unit == null:
		return 0.0

	var unit: UnitData = attacker.unit
	var base_attack: float = float(unit.attack)
	if unit.has_method("compute_attack_power"):
		base_attack = float(unit.compute_attack_power(ammo_damage_config))
	base_attack = max(base_attack, 0.0)

	var morale_factor: float = clamp(unit.morale, 0.1, 1.25)
	var cohesion_factor: float = lerp(0.35, 1.0, clamp(unit.cohesion, 0.0, 1.0))
	var equipment_factor: float = lerp(0.4, 1.0, clamp(unit.state_equipment, 0.0, 1.0))
	var movement_factor: float = 1.0
	if attacker.move_state() == ScenarioUnit.MoveState.MOVING:
		movement_factor = 0.9

	return base_attack * morale_factor * cohesion_factor * equipment_factor * movement_factor
```
