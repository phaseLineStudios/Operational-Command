# LOSAdapter::has_los Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 36–44)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

## Description

Returns true if there is an unobstructed LOS from [param a] to [param b].
[param a] Attacking/observing unit.
[param b] Defending/observed unit.
[return] True if LOS is clear, otherwise false.

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
