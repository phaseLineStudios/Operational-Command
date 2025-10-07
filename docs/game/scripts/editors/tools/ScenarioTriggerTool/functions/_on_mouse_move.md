# ScenarioTriggerTool::_on_mouse_move Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 28–37)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

**Signature**

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool
```

## Source

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not editor or not editor.ctx or not editor.ctx.data or not editor.ctx.data.terrain:
		_hover_valid = false
		return false
	_hover_map_pos = editor.terrain_render.map_to_terrain(e.position)
	_hover_valid = editor.terrain_render.is_inside_map(_hover_map_pos)
	emit_signal("request_redraw_overlay")
	return true
```
