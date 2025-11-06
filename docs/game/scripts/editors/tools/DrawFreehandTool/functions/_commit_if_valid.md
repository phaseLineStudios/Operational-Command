# DrawFreehandTool::_commit_if_valid Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 96–110)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

**Signature**

```gdscript
func _commit_if_valid() -> void
```

## Description

Commit current stroke.

## Source

```gdscript
func _commit_if_valid() -> void:
	if _points_m.size() < 2 or editor.ctx.data == null:
		return
	var st := ScenarioDrawingStroke.new()
	st.id = editor.draw_tools.next_drawing_id("stroke")
	st.color = color
	st.width_px = width_px
	st.opacity = opacity
	st.points_m = _points_m.duplicate()
	st.order = Time.get_ticks_usec()
	if editor.ctx.data.drawings == null:
		editor.ctx.data.drawings = []
	editor.history.push_res_insert(editor.ctx.data, "drawings", "id", st, "Draw Stroke")
	_points_m.clear()  # Clear preview points after commit so undo works correctly
	editor.ctx.request_overlay_redraw()
```
