# TriggerAPI::time_scale Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 49–52)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func time_scale() -> float
```

- **Return Value**: Current time scale multiplier.

## Description

Get current time scale (1.0 = normal, 2.0 = 2x speed).

## Source

```gdscript
func time_scale() -> float:
	return sim.get_time_scale() if sim else 1.0
```
