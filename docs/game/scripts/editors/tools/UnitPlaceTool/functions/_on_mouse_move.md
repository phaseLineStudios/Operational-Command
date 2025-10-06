# UnitPlaceTool::_on_mouse_move Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 51–63)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

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
	var mp := editor.terrain_render.map_to_terrain(e.position)
	if snap_to_grid or Input.is_key_pressed(KEY_SHIFT):
		mp = _snap(mp)
	_hover_map_pos = mp
	_hover_valid = editor.terrain_render.is_inside_map(mp)
	emit_signal("request_redraw_overlay")
	return true
```
