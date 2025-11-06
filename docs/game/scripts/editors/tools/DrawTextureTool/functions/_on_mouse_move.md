# DrawTextureTool::_on_mouse_move Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 38–46)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool
```

- **e**: InputEventMouseMotion.
- **Return Value**: true if consumed.

## Description

Handle mouse move.

## Source

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not texture:
		return false
	_hover_m = editor.ctx.terrain_render.map_to_terrain(e.position)
	_has_hover = true
	request_redraw_overlay.emit()
	return true
```
