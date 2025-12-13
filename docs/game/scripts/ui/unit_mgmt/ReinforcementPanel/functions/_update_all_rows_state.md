# ReinforcementPanel::_update_all_rows_state Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 229–274)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _update_all_rows_state() -> void
```

## Description

Refresh values, slider ranges, title/colour, and badge for all rows.

## Source

```gdscript
func _update_all_rows_state() -> void:
	for u: UnitData in _units:
		var uid: String = u.id
		var w: RowWidgets = _rows.get(uid, null)
		if w == null:
			continue
		var cur: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var req: int = int(_pending.get(uid, 0))

		w.value.text = str(req)
		w.slider.min_value = 0.0
		w.slider.max_value = float(cap)
		# Ensure slider value doesn't go below current strength
		var target_value: float = float(cur + req)
		if target_value < float(cur):
			target_value = float(cur)
		w.slider.value = target_value
		w.max_lbl.text = "/ %d" % missing
		w.current_max_label.text = "Personnel: %d / %d" % [cur, cap]

		var wiped: bool = cur <= 0
		_disable_row(w, wiped or (_pool_remaining <= 0 and req <= 0))

		# Title styling toggles with state
		if wiped:
			w.title.text = w.base_title + " (Wiped Out)"
			w.title.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		else:
			w.title.text = w.base_title
			if w.title.has_theme_color_override("font_color"):
				w.title.remove_theme_color_override("font_color")

		# Badge reflects current state
		var thr := (
			u.understrength_threshold
			if u.understrength_threshold > 0.0
			else understrength_threshold
		)
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		w.badge.set_unit(u, cur_strength, thr)

	_update_pool_labels()
```
