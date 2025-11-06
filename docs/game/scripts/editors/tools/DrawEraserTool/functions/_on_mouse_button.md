# DrawEraserTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 38–48)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

- **e**: InputEventMouseButton.
- **Return Value**: true if consumed.

## Description

Handle mouse button - erase drawing on click.

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e or editor.ctx.data == null:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		var clicked_m := editor.ctx.terrain_render.map_to_terrain(e.position)
		var erased := _find_and_erase_drawing(clicked_m, e.position)
		if erased:
			return true
	return false
```
