# TerrainPolygonTool::_cancel_edit_delete_polygon Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 328–345)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

**Signature**

```gdscript
func _cancel_edit_delete_polygon() -> void
```

## Description

Delete polygon

## Source

```gdscript
func _cancel_edit_delete_polygon() -> void:
	if data == null or _edit_idx < 0:
		return
	var d: Dictionary = data.surfaces[_edit_idx]
	var id = d.get("id", null)
	if id == null:
		return
	var copy := d.duplicate(true)
	editor.history.push_item_erase_by_id(data, "surfaces", id, copy, "Delete polygon", _edit_idx)
	data.remove_surface(_edit_id)
	_edit_id = -1
	_edit_idx = -1
	_drag_idx = -1
	_hover_idx = -1
	_is_drag = false
	_queue_preview_redraw()
```
