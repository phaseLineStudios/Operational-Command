# TerrainLineTool::_cancel_edit_delete_line Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 343–359)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _cancel_edit_delete_line() -> void
```

## Source

```gdscript
func _cancel_edit_delete_line() -> void:
	if data == null or _edit_idx < 0:
		return
	var d: Dictionary = data.lines[_edit_idx]
	var id = d.get("id", null)
	if id == null:
		return
	var copy := d.duplicate(true)
	editor.history.push_item_erase_by_id(data, "lines", id, copy, "Delete line", _edit_idx)
	data.remove_line(_edit_id)
	_edit_id = -1
	_edit_idx = -1
	_drag_idx = -1
	_hover_idx = -1
	_is_drag = false
```
