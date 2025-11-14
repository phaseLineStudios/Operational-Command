# LOSAdapter::_behaviour_spotting_mult Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 155–170)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _behaviour_spotting_mult(target: ScenarioUnit) -> float
```

## Source

```gdscript
func _behaviour_spotting_mult(target: ScenarioUnit) -> float:
	if target == null:
		return 1.0
	match target.behaviour:
		ScenarioUnit.Behaviour.CARELESS:
			return 1.1
		ScenarioUnit.Behaviour.SAFE:
			return 1.0
		ScenarioUnit.Behaviour.AWARE:
			return 0.9
		ScenarioUnit.Behaviour.COMBAT:
			return 0.8
		ScenarioUnit.Behaviour.STEALTH:
			return 0.6
		_:
			return 1.0
```
