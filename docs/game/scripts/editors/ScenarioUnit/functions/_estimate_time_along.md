# ScenarioUnit::_estimate_time_along Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 233–248)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _estimate_time_along(grid: PathGrid, pts: PackedVector2Array) -> float
```

## Description

Sum time for a polyline using mid-segment speed.

## Source

```gdscript
func _estimate_time_along(grid: PathGrid, pts: PackedVector2Array) -> float:
	if pts.size() < 2:
		return 0.0
	var t := 0.0
	for i in range(1, pts.size()):
		var a := pts[i - 1]
		var b := pts[i]
		var d := a.distance_to(b)
		var mid := (a + b) * 0.5
		var v := _speed_here_mps(grid, mid)
		if v <= 0.0:
			return INF
		t += d / v
	return t
```
