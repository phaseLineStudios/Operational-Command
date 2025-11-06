# DrawFreehandTool::_on_mouse_move Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 35–47)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

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
	if _dragging and (e.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		var mp := editor.ctx.terrain_render.map_to_terrain(e.position)
		if not _last_m.is_finite() or mp.distance_to(_last_m) >= min_step_m:
			_points_m.push_back(mp)
			_last_m = mp
			request_redraw_overlay.emit()
		return true
	return false
```
