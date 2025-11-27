# TerrainPointTool::_remove_point Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 237–248)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _remove_point(idx_in_points: int) -> void
```

## Source

```gdscript
func _remove_point(idx_in_points: int) -> void:
	if data == null or idx_in_points < 0 or idx_in_points >= data.points.size():
		return
	var s: Dictionary = data.points[idx_in_points]
	var id = s.get("id", null)
	if id == null:
		return
	var copy := s.duplicate(true)
	editor.history.push_item_erase_by_id(data, "points", id, copy, "Delete point", idx_in_points)
	data.remove_point(data.points[idx_in_points].id)
```
