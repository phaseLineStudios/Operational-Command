# ScenarioUnit::estimate_eta_s Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 258–267)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func estimate_eta_s(grid: PathGrid) -> float
```

## Description

Estimate remaining time using grid weights (cheap mid-segment sampling).

## Source

```gdscript
func estimate_eta_s(grid: PathGrid) -> float:
	if grid == null or _move_path.size() < 1:
		return 0.0
	var pts := PackedVector2Array()
	pts.append(position_m)
	for i in range(_move_path_idx, _move_path.size()):
		pts.append(_move_path[i])
	return _estimate_time_along(grid, pts)
```
