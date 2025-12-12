# MovementAdapter::path_complexity_for Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 582–602)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func path_complexity_for(_su: ScenarioUnit) -> float
```

## Description

Optional helper to surface path complexity to env system (placeholder).

## Source

```gdscript
func path_complexity_for(_su: ScenarioUnit) -> float:
	if _su == null or not _su.has_method("current_path"):
		return 0.0
	var path: PackedVector2Array = _su.current_path()
	if path.is_empty():
		return 0.0
	var total_len: float = 0.0
	var turn_sum: float = 0.0
	for i in range(1, path.size()):
		total_len += path[i - 1].distance_to(path[i])
		if i >= 2:
			var a := (path[i - 1] - path[i - 2]).normalized()
			var b := (path[i] - path[i - 1]).normalized()
			var dot: float = clamp(a.dot(b), -1.0, 1.0)
			var turn: float = acos(dot)
			turn_sum += turn
	var norm_len: float = clamp(total_len / 1000.0, 0.0, 1.0)
	var norm_turns: float = clamp(turn_sum / PI, 0.0, 1.0)
	return clamp((norm_len * 0.6) + (norm_turns * 0.4), 0.0, 1.0)
```
