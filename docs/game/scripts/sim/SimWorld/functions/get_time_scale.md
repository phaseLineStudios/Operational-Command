# SimWorld::get_time_scale Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 523–526)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_time_scale() -> float
```

- **Return Value**: Current time scale multiplier.

## Description

Get current simulation time scale (1.0 = normal, 2.0 = 2x speed, 0.0 = paused).

## Source

```gdscript
func get_time_scale() -> float:
	return _time_scale
```
