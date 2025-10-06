# TerrainLineTool::build_options_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 66–135)</br>
*Belongs to:* [TerrainLineTool](../TerrainLineTool.md)

**Signature**

```gdscript
func build_options_ui(p: Control) -> void
```

## Source

```gdscript
func build_options_ui(p: Control) -> void:
	_load_brushes()

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_child(vb)

	vb.add_child(_label("Feature Brush"))

	var list := ItemList.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list.custom_minimum_size = Vector2(0, 160)

	var map_index := []
	for brush_idx in brushes.size():
		var brush: TerrainBrush = brushes[brush_idx]
		list.add_item(brush.legend_title)
		map_index.append(brush_idx)

	list.item_selected.connect(
		func(i):
			if i >= 0 and i < map_index.size():
				active_brush = brushes[map_index[i]]
				_sync_edit_brush_to_active_if_needed()
				_rebuild_info_ui()
	)
	vb.add_child(list)

	var s := HSlider.new()
	s.min_value = 0.5
	s.max_value = 12.0
	s.step = 0.5
	s.value = line_width_px
	s.value_changed.connect(
		func(v: float):
			var new_w := v
			if _edit_idx >= 0:
				if _width_before < 0.0:
					_width_before = float(data.lines[_edit_idx].get("width_px", line_width_px))
				line_width_px = new_w
				data.set_line_style(_edit_id, line_width_px)
			else:
				line_width_px = new_w
	)

	# When the slider loses focus or mouse released, commit an undo step if editing
	s.gui_input.connect(
		func(e):
			if (
				e is InputEventMouseButton
				and e.button_index == MOUSE_BUTTON_LEFT
				and not e.pressed
				and _edit_idx >= 0
				and _width_before >= 0.0
			):
				var before: Dictionary = data.lines[_edit_idx].duplicate(true)
				before["width_px"] = _width_before
				var after: Dictionary = data.lines[_edit_idx].duplicate(true)
				if before != after:
					editor.history.push_item_edit_by_id(
						data, "lines", after.get("id"), before, after, "Change line width"
					)
				_width_before = -1.0
	)
	vb.add_child(_label("Line width (px)"))
	vb.add_child(s)
```
