# TerrainLabelTool::handle_view_input Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 108–167)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

## Source

```gdscript
func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		_hover_idx = _pick_label(event.position)
		if _is_drag and _drag_idx >= 0:
			if not render.is_inside_terrain(event.position):
				return false

			if event.position.is_finite():
				var local_m := editor.map_to_terrain(event.position)
				_set_label_pos(_drag_idx, local_m)
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_terrain(event.position):
				return false

			_hover_idx = _pick_label(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = (
					data.labels[_drag_idx].duplicate(true)
					if _drag_idx >= 0 and _drag_idx < data.labels.size()
					else {}
				)
			else:
				if event.position.is_finite():
					var local_m := editor.map_to_terrain(event.position)
					_add_label(local_m, label_text, label_size)
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _drag_idx < data.labels.size() and _drag_before.size() > 0:
				var after: Dictionary = data.labels[_drag_idx].duplicate(true)
				if after != _drag_before:
					var id: int = after.get("id", null)
					if id != null:
						editor.history.push_item_edit_by_id(
							data, "labels", id, _drag_before, after, "Move label"
						)
			_drag_idx = -1
			_drag_before = {}
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _hover_idx >= 0:
					_remove_label(_hover_idx)
					_hover_idx = -1
				return true
			KEY_ESCAPE:
				_is_drag = false
				_drag_idx = -1
				return true

	return false
```
