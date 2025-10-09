# LOSAdapter::spotting_mul Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 51–58)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float
```

## Description

Computes a spotting multiplier (0..1) at [param range_m] from [param pos_d].
Values near 0 reduce detection; 1 means no penalty.
[param pos_d] Defender position in meters (terrain space).
[param range_m] Range from observer to defender in meters.
[param weather_severity] Optional 0..1 weather penalty factor.
[return] Spotting multiplier in [0, 1].

## Source

```gdscript
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float:
	if _los == null or _renderer == null or _renderer.data == null:
		return 1.0
	return _los.compute_spotting_mul(
		_renderer, _renderer.data, pos_d, range_m, weather_severity, effects_config
	)
```
