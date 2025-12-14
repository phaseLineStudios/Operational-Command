# MovementAdapter::_desired_bias_weight Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 626–638)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _desired_bias_weight(su: ScenarioUnit) -> float
```

## Source

```gdscript
func _desired_bias_weight(su: ScenarioUnit) -> float:
	if su == null or not su.has_meta("env_navigation_bias"):
		return _grid.road_bias_weight
	var bias: StringName = StringName(su.get_meta("env_navigation_bias"))
	match String(bias):
		"roads":
			return 0.5
		"cover":
			return 1.2
		"shortest":
			return 1.0
		_:
			return _grid.road_bias_weight
```
