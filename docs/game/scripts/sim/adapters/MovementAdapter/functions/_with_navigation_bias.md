# MovementAdapter::_with_navigation_bias Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 615–625)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _with_navigation_bias(su: ScenarioUnit, action: Callable) -> Variant
```

## Source

```gdscript
func _with_navigation_bias(su: ScenarioUnit, action: Callable) -> Variant:
	if _grid == null:
		return action.call()
	var prev: float = _grid.road_bias_weight
	var bias_weight: float = _desired_bias_weight(su)
	_grid.road_bias_weight = bias_weight
	var result: Variant = action.call()
	_grid.road_bias_weight = prev
	return result
```
