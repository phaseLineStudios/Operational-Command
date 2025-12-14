# SimWorld::set_time_scale Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 516–519)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func set_time_scale(scale: float) -> void
```

## Description

Set simulation time scale (1.0 = normal, 2.0 = 2x speed).

## Source

```gdscript
func set_time_scale(scale: float) -> void:
	_time_scale = max(0.0, scale)
```
