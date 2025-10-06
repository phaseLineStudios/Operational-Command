# TerrainPointTool::_add_point Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 211–226)</br>
*Belongs to:* [TerrainPointTool](../TerrainPointTool.md)

**Signature**

```gdscript
func _add_point(local_m: Vector2) -> void
```

## Source

```gdscript
func _add_point(local_m: Vector2) -> void:
	if data == null:
		return
	_ensure_surfaces()
	var pid := randi()
	var point := {
		"id": pid,
		"brush": active_brush,
		"pos": local_m,
		"scale": symbol_scale,
		"rot": symbol_rotation_deg
	}
	data.add_point(point)
	editor.history.push_item_insert(data, "points", point, "Add point", data.points.size())
```
