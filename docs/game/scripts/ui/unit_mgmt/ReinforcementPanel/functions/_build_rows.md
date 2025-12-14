# ReinforcementPanel::_build_rows Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 126–220)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _build_rows() -> void
```

## Description

Create row widgets for current units.

## Source

```gdscript
func _build_rows() -> void:
	for u: UnitData in _units:
		var uid: String = u.id
		var current: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - current)

		# Main container for this unit (vertical stack)
		var unit_vbox := VBoxContainer.new()
		unit_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_theme_constant_override("separation", 6)
		_rows_box.add_child(unit_vbox)

		# Top row: Title and Badge
		var top_row := HBoxContainer.new()
		top_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(top_row)

		var title := Label.new()
		var base_title := u.title if u.title != "" else uid
		title.text = base_title
		title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top_row.add_child(title)

		var badge := UnitStrengthBadge.new()
		badge.custom_minimum_size = Vector2(60, 0)
		var thr := (
			u.understrength_threshold
			if u.understrength_threshold > 0.0
			else understrength_threshold
		)
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		badge.set_unit(u, cur_strength, thr)
		top_row.add_child(badge)

		# Middle row: Current/Max label
		var current_max_label := Label.new()
		current_max_label.text = "Personnel: %d / %d" % [current, cap]
		unit_vbox.add_child(current_max_label)

		# Bottom row: Controls
		var controls_row := HBoxContainer.new()
		controls_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(controls_row)

		var minus := Button.new()
		minus.text = "-"
		controls_row.add_child(minus)

		var val := Label.new()
		val.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		val.text = str(int(_pending.get(uid, 0)))
		controls_row.add_child(val)

		var plus := Button.new()
		plus.text = "+"
		controls_row.add_child(plus)

		var max_lbl := Label.new()
		max_lbl.text = "/ %d" % missing
		controls_row.add_child(max_lbl)

		# Slider on its own row below (shows total strength from 0, blocks below current)
		var slider := HSlider.new()
		slider.step = slider_step
		slider.min_value = 0.0
		slider.max_value = float(cap)
		slider.value = float(current + _pending.get(uid, 0))
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(slider)

		var widgets := RowWidgets.new(
			unit_vbox, title, badge, current_max_label, minus, val, plus, slider, max_lbl
		)
		widgets.base_title = base_title
		_rows[uid] = widgets

		minus.pressed.connect(func() -> void: _nudge(uid, -1))
		plus.pressed.connect(func() -> void: _nudge(uid, +1))
		slider.value_changed.connect(
			func(v: float) -> void:
				var cur_str: int = int(round(_unit_strength.get(uid, 0.0)))
				var target_total: int = int(round(v))
				# Block slider from going below current strength
				if target_total < cur_str:
					slider.value = float(cur_str)
					return
				var reinforcements: int = target_total - cur_str
				_set_amount(uid, reinforcements)
		)

	_update_all_rows_state()
```
