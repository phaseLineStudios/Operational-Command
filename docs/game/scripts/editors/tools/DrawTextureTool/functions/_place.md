# DrawTextureTool::_place Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 93–107)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func _place() -> void
```

## Description

Commit a stamp.

## Source

```gdscript
func _place() -> void:
	var st := ScenarioDrawingStamp.new()
	st.id = editor.draw_tools.next_drawing_id("stamp")
	st.texture_path = texture_path
	st.modulate = color
	st.opacity = opacity
	st.position_m = _hover_m
	st.scale = scale * 0.1
	st.rotation_deg = rotation_deg
	st.label = label
	st.order = Time.get_ticks_usec()
	if editor.ctx.data.drawings == null:
		editor.ctx.data.drawings = []
	editor.history.push_res_insert(editor.ctx.data, "drawings", "id", st, "Place Stamp")
	editor.ctx.request_overlay_redraw()
```
