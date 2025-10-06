# TerrainElevationTool::build_options_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 50–89)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func build_options_ui(p: Control) -> void
```

## Source

```gdscript
func build_options_ui(p: Control) -> void:
	var vb := VBoxContainer.new()
	p.add_child(vb)
	var lb := OptionButton.new()
	lb.add_item("Raise", Mode.RAISE)
	lb.add_item("Lower", Mode.LOWER)
	lb.add_item("Smooth", Mode.SMOOTH)
	lb.selected = mode
	lb.item_selected.connect(func(i): mode = i)
	vb.add_child(_label("Mode"))
	vb.add_child(lb)

	var r := HSlider.new()
	r.min_value = 5
	r.max_value = 200
	r.step = 1
	r.value = brush_radius_m
	r.value_changed.connect(func(v): brush_radius_m = v)
	vb.add_child(_label("Radius (m)"))
	vb.add_child(r)

	var f := HSlider.new()
	f.min_value = 0.0
	f.max_value = 1.0
	f.step = 0.01
	f.value = falloff_p
	f.value_changed.connect(func(v): falloff_p = v)
	vb.add_child(_label("Falloff"))
	vb.add_child(f)

	var s := HSlider.new()
	s.min_value = 0.1
	s.max_value = 10
	s.step = 0.1
	s.value = strength_m
	s.value_changed.connect(func(v): strength_m = v)
	vb.add_child(_label("Strength (m)"))
	vb.add_child(s)
```
