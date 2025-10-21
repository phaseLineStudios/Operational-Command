# MovementAgent::eta_seconds Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 242–250)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func eta_seconds() -> float
```

## Description

ETA (seconds) along current remaining path with current base speed.

## Source

```gdscript
func eta_seconds() -> float:
	if not grid or _path.size() <= 1 or not _moving:
		return 0.0
	var rem := PackedVector2Array()
	for i in range(_path_idx, _path.size()):
		rem.append(_path[i])
	return grid.estimate_travel_time_s(rem, base_speed_mps, profile)
```
