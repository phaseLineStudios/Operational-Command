# TerrainLineTool::_sync_edit_brush_to_active_if_needed Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 367–374)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _sync_edit_brush_to_active_if_needed() -> void
```

## Source

```gdscript
func _sync_edit_brush_to_active_if_needed() -> void:
	if data == null or _edit_idx < 0 or active_brush == null:
		return
	var s: Dictionary = data.lines[_edit_idx]
	if s.get("brush") != active_brush:
		data.set_line_brush(_edit_id, active_brush)
```
