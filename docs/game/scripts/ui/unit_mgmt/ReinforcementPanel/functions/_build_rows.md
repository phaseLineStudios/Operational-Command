# ReinforcementPanel::_build_rows Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 114–181)</br>
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
		var current: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - current)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_rows_box.add_child(row)

		var title := Label.new()
		title.custom_minimum_size = Vector2(row_label_min_w, 0.0)
		var base_title := u.title if u.title != "" else uid
		title.text = base_title
		row.add_child(title)

		var badge := UnitStrengthBadge.new()
		badge.custom_minimum_size = Vector2(60, 0)
		var thr := (
			u.understrength_threshold
			if u.understrength_threshold > 0.0
			else understrength_threshold
		)
		badge.set_unit(u, thr)
		row.add_child(badge)

		var spacer := Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(spacer)

		var minus := Button.new()
		minus.text = "-"
		row.add_child(minus)

		var val := Label.new()
		val.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		val.text = str(int(_pending.get(uid, 0)))
		row.add_child(val)

		var plus := Button.new()
		plus.text = "+"
		row.add_child(plus)

		var slider := HSlider.new()
		slider.step = slider_step
		slider.min_value = 0.0
		slider.max_value = float(missing)
		slider.value = float(_pending.get(uid, 0))
		slider.custom_minimum_size = Vector2(120, 0)
		row.add_child(slider)

		var max_lbl := Label.new()
		max_lbl.text = "/ %d" % missing
		row.add_child(max_lbl)

		var widgets := RowWidgets.new(row, title, badge, minus, val, plus, slider, max_lbl)
		widgets.base_title = base_title
		_rows[uid] = widgets

		minus.pressed.connect(func() -> void: _nudge(uid, -1))
		plus.pressed.connect(func() -> void: _nudge(uid, +1))
		slider.value_changed.connect(func(v: float) -> void: _set_amount(uid, int(round(v))))

	_update_all_rows_state()
```
