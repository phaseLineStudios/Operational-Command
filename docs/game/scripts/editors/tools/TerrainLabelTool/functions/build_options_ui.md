# TerrainLabelTool::build_options_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 51–91)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func build_options_ui(parent: Control) -> void
```

## Source

```gdscript
func build_options_ui(parent: Control) -> void:
	var vb := VBoxContainer.new()
	parent.add_child(vb)

	vb.add_child(_label("Text"))
	var te := LineEdit.new()
	te.text = label_text
	te.text_changed.connect(
		func(t):
			label_text = t
			_refresh_preview()
	)
	vb.add_child(te)

	vb.add_child(_label("Font size"))
	var s := HSlider.new()
	s.min_value = 8
	s.max_value = 96
	s.step = 1
	s.value = label_size
	s.value_changed.connect(
		func(v):
			label_size = int(v)
			_refresh_preview()
	)
	vb.add_child(s)

	var rot_slider := HSlider.new()
	rot_slider.min_value = -180.0
	rot_slider.max_value = 180.0
	rot_slider.step = 1.0
	rot_slider.value = label_rotation_deg
	rot_slider.value_changed.connect(
		func(v):
			label_rotation_deg = v
			_refresh_preview()
	)
	vb.add_child(_label("Rotation (°)"))
	vb.add_child(rot_slider)
```
