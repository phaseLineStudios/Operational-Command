# TriggerAPI::time_s Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 27–30)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func time_s() -> float
```

- **Return Value**: Mission time in seconds.

## Description

Return mission time in seconds.

## Source

```gdscript
func time_s() -> float:
	return sim.get_mission_time_s() if sim else 0.0
```
