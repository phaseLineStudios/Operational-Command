# PathGrid::_slope_multiplier_at_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 635–655)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _slope_multiplier_at_cell(cx: int, cy: int) -> float
```

## Source

```gdscript
func _slope_multiplier_at_cell(cx: int, cy: int) -> float:
	if data == null or data.elevation == null or data.elevation.is_empty():
		return 1.0
	var p := _cell_center_m(Vector2i(cx, cy))

	var sx := cell_size_m * 0.5
	var sy := cell_size_m * 0.5
	var e_r := _elev_m_at(p + Vector2(sx, 0.0))
	var e_l := _elev_m_at(p - Vector2(sx, 0.0))
	var e_u := _elev_m_at(p - Vector2(0.0, sy))
	var e_d := _elev_m_at(p + Vector2(0.0, sy))

	var dx: float = (e_r - e_l) / max(cell_size_m, 0.001)
	var dy: float = (e_d - e_u) / max(cell_size_m, 0.001)
	var grade := sqrt(dx * dx + dy * dy)

	if grade >= max_traversable_grade:
		return INF
	return 1.0 + slope_multiplier_per_grade * grade
```
