# DrawFreehandTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 51–70)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

- **e**: InputEventMouseButton.
- **Return Value**: true if consumed.

## Description

Handle mouse button.

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e or editor.ctx.data == null:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		_dragging = true
		_points_m.clear()
		_last_m = Vector2.INF
		var mp := editor.ctx.terrain_render.map_to_terrain(e.position)
		_points_m.push_back(mp)
		_last_m = mp
		request_redraw_overlay.emit()
		return true
	if e.button_index == MOUSE_BUTTON_LEFT and not e.pressed and _dragging:
		_dragging = false
		_commit_if_valid()
		request_redraw_overlay.emit()
		return true
	return false
```
