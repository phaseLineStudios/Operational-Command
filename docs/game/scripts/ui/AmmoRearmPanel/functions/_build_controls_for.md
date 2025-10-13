# AmmoRearmPanel::_build_controls_for Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 76–158)</br>
*Belongs to:* [AmmoRearmPanel](../../AmmoRearmPanel.md)

**Signature**

```gdscript
func _build_controls_for(u: UnitData) -> void
```

## Source

```gdscript
func _build_controls_for(u: UnitData) -> void:
	_clear_children(_box_ammo)
	_sliders_ammo.clear()
	_sliders_stock.clear()

	# --- Section: Unit ammo (state_ammunition) ---
	if not u.ammunition.is_empty():
		_add_section_label("Unit ammo")
		for t in u.ammunition.keys():
			var cur: int = int(u.state_ammunition.get(t, 0))
			var cap: int = int(u.ammunition[t])
			var depot_avail: int = int(_depot.get(t, 0))
			var max_target: int = cur + int(min(cap - cur, depot_avail))

			var row := HBoxContainer.new()
			_box_ammo.add_child(row)

			var lab := Label.new()
			lab.text = "%s  %d/%d" % [str(t), cur, cap]
			row.add_child(lab)

			var slider := HSlider.new()
			slider.min_value = cur
			slider.max_value = max_target
			slider.step = 1.0
			slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			slider.value = cur
			row.add_child(slider)

			var val := Label.new()
			val.text = "→ %d (+0)" % [cur]
			row.add_child(val)

			var entry := SliderEntry.new()
			entry.slider = slider
			entry.base = cur
			_sliders_ammo[t] = entry

			slider.value_changed.connect(
				func(v: float) -> void:
					var delta: int = int(v) - cur
					val.text = "→ %d (%+d)" % [int(v), delta]
			)

	# --- Section: Logistics payload (throughput stock) ---
	if u.throughput is Dictionary and not u.throughput.is_empty():
		_add_section_label("Payload (logistics stock)")
		for t in u.throughput.keys():
			var cur_stock: int = int(u.throughput[t])
			var depot_avail2: int = int(_depot.get(t, 0))
			var max_target2: int = cur_stock + depot_avail2  # no explicit cap in spec

			var row2 := HBoxContainer.new()
			_box_ammo.add_child(row2)

			var lab2 := Label.new()
			lab2.text = "%s  stock %d" % [str(t), cur_stock]
			row2.add_child(lab2)

			var slider2 := HSlider.new()
			slider2.min_value = cur_stock
			slider2.max_value = max_target2
			slider2.step = 1.0
			slider2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			slider2.value = cur_stock
			row2.add_child(slider2)

			var val2 := Label.new()
			val2.text = "→ %d (+0)" % [cur_stock]
			row2.add_child(val2)

			var entry2 := SliderEntry.new()
			entry2.slider = slider2
			entry2.base = cur_stock
			_sliders_stock[t] = entry2

			slider2.value_changed.connect(
				func(v: float) -> void:
					var delta2: int = int(v) - cur_stock
					val2.text = "→ %d (%+d)" % [int(v), delta2]
			)
```
