# AmmoRearmPanel::_apply_fill_ratio Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 162–182)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _apply_fill_ratio(ratio: float) -> void
```

## Source

```gdscript
func _apply_fill_ratio(ratio: float) -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	# Only auto-fill unit ammo. Payload stays manual.
	for t in u.ammunition.keys():
		var cur: int = int(u.state_ammunition.get(t, 0))
		var cap: int = int(u.ammunition[t])
		var depot_avail: int = int(_depot.get(t, 0))

		var want: int = int(round(float(cap) * ratio))
		var need: int = max(0, want - cur)
		var give: int = int(min(need, depot_avail))

		var entry: SliderEntry = _sliders_ammo.get(t, null) as SliderEntry
		if entry != null and entry.slider != null:
			entry.slider.value = cur + give  # updates the label via value_changed
```
