# DrawEraserTool::_on_mouse_move Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 27–34)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

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
	if not e:
		return false
	_mouse_pos_px = e.position
	request_redraw_overlay.emit()
	return false
```
