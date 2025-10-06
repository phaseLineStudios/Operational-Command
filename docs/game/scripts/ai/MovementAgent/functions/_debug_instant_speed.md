# MovementAgent::_debug_instant_speed Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 187–194)</br>
*Belongs to:* [MovementAgent](../MovementAgent.md)

**Signature**

```gdscript
func _debug_instant_speed(delta: float) -> float
```

## Description

Compute instantaneous speed (m/s) based on last trail step.

## Source

```gdscript
func _debug_instant_speed(delta: float) -> float:
	if delta <= 0.0 or _trail.size() < 2:
		return 0.0
	var a := _trail[_trail.size() - 2]
	var b := _trail[_trail.size() - 1]
	return a.distance_to(b) / delta
```
