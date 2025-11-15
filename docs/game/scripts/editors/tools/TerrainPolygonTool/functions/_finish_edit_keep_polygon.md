# TerrainPolygonTool::_finish_edit_keep_polygon Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 348–356)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _finish_edit_keep_polygon() -> void
```

## Description

Stop editing and save polygon

## Source

```gdscript
func _finish_edit_keep_polygon() -> void:
	_edit_id = -1
	_edit_idx = -1
	_drag_idx = -1
	_hover_idx = -1
	_is_drag = false
	_queue_preview_redraw()
```
