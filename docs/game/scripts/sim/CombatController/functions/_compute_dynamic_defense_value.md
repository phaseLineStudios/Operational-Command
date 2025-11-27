# CombatController::_compute_dynamic_defense_value Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 504–519)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _compute_dynamic_defense_value(defender: ScenarioUnit) -> float
```

## Description

Computes the defender's mitigation modifier that scales incoming damage.

## Source

```gdscript
func _compute_dynamic_defense_value(defender: ScenarioUnit) -> float:
	if defender == null or defender.unit == null:
		return 0.0

	var unit: UnitData = defender.unit
	var base_defense: float = max(unit.defense, 0.0)
	var morale_factor: float = lerp(0.4, 1.0, clamp(unit.morale, 0.0, 1.0))
	var cohesion_factor: float = lerp(0.4, 1.0, clamp(unit.cohesion, 0.0, 1.0))
	var equipment_factor: float = lerp(0.35, 1.0, clamp(unit.state_equipment, 0.0, 1.0))
	var movement_factor: float = 1.0
	if defender.move_state() == ScenarioUnit.MoveState.MOVING:
		movement_factor = 0.75

	return base_defense * morale_factor * cohesion_factor * equipment_factor * movement_factor
```
