# EnvBehaviorSystem::_behaviour_loss_factor Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 286–303)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _behaviour_loss_factor(unit: ScenarioUnit) -> float
```

## Description

Behaviour profile influence on getting lost.

## Source

```gdscript
func _behaviour_loss_factor(unit: ScenarioUnit) -> float:
	if unit == null:
		return 1.0
	match unit.behaviour:
		ScenarioUnit.Behaviour.CARELESS:
			return 1.25
		ScenarioUnit.Behaviour.SAFE:
			return 1.0
		ScenarioUnit.Behaviour.AWARE:
			return 0.9
		ScenarioUnit.Behaviour.COMBAT:
			return 0.85
		ScenarioUnit.Behaviour.STEALTH:
			return 0.7
		_:
			return 1.0
```
