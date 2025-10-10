# LOSAdapter::has_los Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 36–44)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

- **a**: Attacking/observing unit.
- **b**: Defending/observed unit.
- **Return Value**: True if LOS is clear, otherwise false.

## Description

Returns true if there is an unobstructed LOS from `a` to `b`.

## Source

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		return false
	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	return not bool(res.get("blocked", false))
```
