# TerrainPointTool::handle_view_input Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 141–204)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

## Source

```gdscript
func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		_hover_idx = _pick_point(event.position)
		if _is_drag and _drag_idx >= 0:
			if not render.is_inside_terrain(event.position):
				return false
			if event.position.is_finite():
				var local_m := editor.map_to_terrain(event.position)
				_set_point_pos(_drag_idx, local_m)
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_terrain(event.position):
				return false

			_hover_idx = _pick_point(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = (
					data.points[_drag_idx].duplicate(true)
					if _drag_idx >= 0 and _drag_idx < data.points.size()
					else {}
				)
			else:
				if (
					active_brush == null
					or active_brush.feature_type != TerrainBrush.FeatureType.POINT
				):
					return true
				if event.position.is_finite():
					var local_m := editor.map_to_terrain(event.position)
					_add_point(local_m)
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _drag_idx < data.points.size() and _drag_before.size() > 0:
				var after: Dictionary = data.points[_drag_idx].duplicate(true)
				if after != _drag_before:
					var id: int = after.get("id", null)
					if id != null:
						editor.history.push_item_edit_by_id(
							data, "points", id, _drag_before, after, "Move point"
						)
			_drag_idx = -1
			_drag_before = {}
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _hover_idx >= 0:
					_remove_point(_hover_idx)
					_hover_idx = -1
				return true
			KEY_ESCAPE:
				_is_drag = false
				_drag_idx = -1
				return true

	return false
```
