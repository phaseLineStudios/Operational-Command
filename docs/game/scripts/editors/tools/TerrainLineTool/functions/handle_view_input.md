# TerrainLineTool::handle_view_input Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 199–302)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

## Source

```gdscript
func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		if _edit_idx >= 0:
			_hover_idx = _pick_point(event.position)
			_queue_preview_redraw()
		if _is_drag and _drag_idx >= 0 and _edit_idx >= 0:
			if not render.is_inside_map(event.position):
				return false

			if event.position.is_finite():
				var local_m := editor.map_to_terrain(event.position)
				var pts := _current_points()
				if _drag_idx >= 0 and _drag_idx < pts.size():
					pts[_drag_idx] = local_m
					data.set_line_points(_edit_id, pts)
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_map(event.position):
				return false

			if _edit_idx < 0:
				_start_new_line()
				_edit_idx = _find_edit_index_by_id()

			var idx := _ensure_current_line_idx()
			if idx < 0:
				return true

			_hover_idx = _pick_point(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = data.lines[_edit_idx].duplicate(true)
				_queue_preview_redraw()
			else:
				if event.position.is_finite():
					_sync_edit_brush_to_active_if_needed()
					var local_m := editor.map_to_terrain(event.position)
					var before: Dictionary = data.lines[idx].duplicate(true)
					var pts_before: PackedVector2Array = before.get("points", PackedVector2Array())
					var pts_after := PackedVector2Array(pts_before)
					pts_after.append(local_m)
					var after := before.duplicate(true)
					after["points"] = pts_after

					editor.history.push_item_edit_by_id(
						data, "lines", before.get("id"), before, after, "Add line point"
					)
					data.set_surface_points(int(before.id), pts_after)

					_queue_preview_redraw()
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _edit_idx >= 0 and _drag_before.size() > 0:
				var after: Dictionary = data.lines[_edit_idx].duplicate(true)
				if after != _drag_before:
					editor.history.push_item_edit_by_id(
						data, "lines", after.get("id"), _drag_before, after, "Move line point"
					)
			_drag_idx = -1
			_drag_before = {}
			_queue_preview_redraw()
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _edit_idx >= 0:
					var before: Dictionary = data.lines[_edit_idx].duplicate(true)
					var pts := _current_points()
					if pts.size() > 0:
						pts.remove_at(pts.size() - 1)
						var after: Dictionary = before.duplicate(true)
						after["points"] = pts
						editor.history.push_item_edit_by_id(
							data, "lines", before.get("id"), before, after, "Remove line point"
						)
						data.lines[_edit_idx] = after
						data.set_line_points(_edit_id, pts)
						_queue_preview_redraw()
				return true

			KEY_ENTER, KEY_KP_ENTER:
				if _edit_idx >= 0:
					var pts2 := _current_points()
					if pts2.size() < 2:
						_cancel_edit_delete_line()
					else:
						_finish_edit_keep_line()
					_queue_preview_redraw()
				return true

			KEY_ESCAPE:
				if _edit_idx >= 0:
					_cancel_edit_delete_line()
					_queue_preview_redraw()
				return true

	return false
```
