# LOSAdapter::has_los Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 80–108)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

- **a**: Attacking/observing unit.
- **b**: Defending/observed unit.
- **Return Value**: True if LOS is clear and within range, otherwise false.

## Description

Returns true if there is an unobstructed LOS from `a` to `b`.
Checks both terrain blocking AND maximum spotting range.

## Source

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		return false

	var range_m := a.position_m.distance_to(b.position_m)
	var base_spot_range := a.unit.spot_m if (a.unit and a.unit.spot_m > 0) else 2000.0
	var behaviour_mult := _behaviour_spotting_mult(b)
	var terrain_mult := 1.0

	if _renderer.data != null:
		terrain_mult = spotting_mul(b.position_m, range_m)

	var effective_spot_range := base_spot_range * terrain_mult * behaviour_mult
	if range_m > effective_spot_range:
		return false

	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	var blocked: bool = res.get("blocked", false)
	var atten_integral: float = res.get("atten_integral", 0.0)

	const ATTEN_BLOCK_THRESHOLD := 3.4
	if atten_integral >= ATTEN_BLOCK_THRESHOLD:
		blocked = true

	return not blocked
```
