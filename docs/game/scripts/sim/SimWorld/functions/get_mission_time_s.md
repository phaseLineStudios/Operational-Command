# SimWorld::get_mission_time_s Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 380–383)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_mission_time_s() -> float
```

- **Return Value**: Elapsed mission time.

## Description

Mission clock in seconds.

## Source

```gdscript
func get_mission_time_s() -> float:
	return float(_tick_idx) * _tick_dt
```
