# SimWorld::get_mission_time_s Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 250–253)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_mission_time_s() -> float
```

## Description

Mission clock in seconds.
[return] Elapsed mission time.

## Source

```gdscript
func get_mission_time_s() -> float:
	return float(_tick_idx) * _tick_dt
```
