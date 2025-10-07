# TerrainPointTool::_set_point_pos Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 227–235)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _set_point_pos(idx_in_points: int, local_m: Vector2) -> void
```

## Source

```gdscript
func _set_point_pos(idx_in_points: int, local_m: Vector2) -> void:
	if data == null or idx_in_points < 0 or idx_in_points >= data.points.size():
		return
	var s: Dictionary = data.points[idx_in_points]
	s["pos"] = local_m
	data.points[idx_in_points] = s
	data.set_point_transform(s.id, local_m, symbol_rotation_deg, symbol_scale)
```
