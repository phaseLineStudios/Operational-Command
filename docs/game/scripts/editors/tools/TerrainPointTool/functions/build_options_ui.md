# TerrainPointTool::build_options_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 33–87)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

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

	var map_index: Array[int] = []
	for i in brushes.size():
		var b: TerrainBrush = brushes[i]
		list.add_item(b.legend_title)
		map_index.append(i)
	list.item_selected.connect(
		func(i):
			if i >= 0 and i < map_index.size():
				active_brush = brushes[map_index[i]]
				_rebuild_info_ui()
				_update_preview_appearance()
	)
	vb.add_child(list)

	var s := HSlider.new()
	s.min_value = 0.1
	s.max_value = 4.0
	s.step = 0.1
	s.value = symbol_scale
	s.value_changed.connect(
		func(v):
			symbol_scale = v
			_update_preview_appearance()
	)
	vb.add_child(_label("Symbol scale"))
	vb.add_child(s)

	var rot_slider := HSlider.new()
	rot_slider.min_value = -180.0
	rot_slider.max_value = 180.0
	rot_slider.step = 1.0
	rot_slider.value = symbol_rotation_deg
	rot_slider.value_changed.connect(
		func(v):
			symbol_rotation_deg = v
			_update_preview_appearance()
	)
	vb.add_child(_label("Rotation (°)"))
	vb.add_child(rot_slider)
```
