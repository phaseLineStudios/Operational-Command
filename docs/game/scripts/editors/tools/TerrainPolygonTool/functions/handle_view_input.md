# TerrainPolygonTool::handle_view_input Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 113–230)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

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
				var local_terrain := editor.map_to_terrain(event.position)

				var pts := _current_points()
				if _drag_idx >= 0 and _drag_idx < pts.size():
					pts[_drag_idx] = local_terrain
					data.set_surface_points(_edit_id, pts)
					_queue_preview_redraw()
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_map(event.position):
				return false

			if _edit_idx < 0:
				_start_new_polygon()
				_edit_idx = _find_edit_index_by_id()

			_hover_idx = _pick_point(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = data.surfaces[_edit_idx].duplicate(true)
				_queue_preview_redraw()
			else:
				if not render.is_inside_map(event.position):
					return false

				if event.position.is_finite():
					var local_terrain := editor.map_to_terrain(event.position)

					var idx := _ensure_current_poly_idx()
					if idx < 0:
						_start_new_polygon()
						idx = _ensure_current_poly_idx()
						if idx < 0:
							return true

					var before: Dictionary = data.surfaces[idx].duplicate(true)
					var pts := before.get("points", PackedVector2Array()) as PackedVector2Array
					var pts_after := PackedVector2Array(pts)
					pts_after.append(local_terrain)

					var after := before.duplicate(true)
					after["points"] = pts_after

					editor.history.push_item_edit_by_id(
						data, "surfaces", before.get("id"), before, after, "Add polygon point"
					)
					data.set_surface_points(before.id, pts_after)

					_queue_preview_redraw()
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _edit_idx >= 0 and _drag_before.size() > 0:
				var after: Dictionary = data.surfaces[_edit_idx].duplicate(true)
				if after != _drag_before:
					editor.history.push_item_edit_by_id(
						data, "surfaces", after.get("id"), _drag_before, after, "Move polygon point"
					)
			_drag_idx = -1
			_drag_before = {}
			_queue_preview_redraw()
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _edit_idx >= 0:
					var before: Dictionary = data.surfaces[_edit_idx].duplicate(true)
					var pts := _current_points()
					if pts.size() > 0:
						pts.remove_at(pts.size() - 1)
						var after := before.duplicate(true)
						after["points"] = pts
						editor.history.push_item_edit_by_id(
							data,
							"surfaces",
							before.get("id"),
							before,
							after,
							"Remove polygon point"
						)
						data.surfaces[_edit_idx] = after
						data.set_surface_points(_edit_id, pts)
						_queue_preview_redraw()
				return true

			KEY_ENTER, KEY_KP_ENTER:
				if _edit_idx >= 0:
					var pts2 := _current_points()
					if pts2.size() < 3:
						_cancel_edit_delete_polygon()
					else:
						_finish_edit_keep_polygon()
						_queue_preview_redraw()
				return true

			KEY_ESCAPE:
				if _edit_idx >= 0:
					_cancel_edit_delete_polygon()
					_queue_preview_redraw()
				return true

	return false
```
