# DrawEraserTool::_find_and_erase_drawing Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 70–96)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _find_and_erase_drawing(pos_m: Vector2, pos_px: Vector2) -> bool
```

- **pos_m**: Click position in terrain space.
- **pos_px**: Click position in screen space.
- **Return Value**: true if a drawing was erased.

## Description

Find and erase a drawing near the click position.

## Source

```gdscript
func _find_and_erase_drawing(pos_m: Vector2, pos_px: Vector2) -> bool:
	if editor.ctx.data.drawings == null or editor.ctx.data.drawings.is_empty():
		return false

	# Check drawings in reverse order (topmost first)
	for i in range(editor.ctx.data.drawings.size() - 1, -1, -1):
		var drawing = editor.ctx.data.drawings[i]
		if drawing == null or not drawing.visible:
			continue

		var hit := false
		if drawing is ScenarioDrawingStroke:
			hit = _is_near_stroke(drawing, pos_m, pos_px)
		elif drawing is ScenarioDrawingStamp:
			hit = _is_near_stamp(drawing, pos_m, pos_px)

		if hit:
			# Delete this drawing via history (provide backup for undo)
			editor.history.push_res_erase_by_id(
				editor.ctx.data, "drawings", "id", drawing.id, drawing, "Erase Drawing", i
			)
			editor.ctx.request_overlay_redraw()
			return true

	return false
```
