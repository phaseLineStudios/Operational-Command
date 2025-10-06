# AmmoRearmPanel::_on_commit Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 183–243)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _on_commit() -> void
```

## Source

```gdscript
func _on_commit() -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	# Apply unit ammo deltas
	for t in _sliders_ammo.keys():
		var e: SliderEntry = _sliders_ammo.get(t, null) as SliderEntry
		if e == null or e.slider == null:
			continue
		var cur: int = e.base
		var target: int = int(e.slider.value)
		var want: int = max(0, target - cur)
		if want <= 0:
			continue

		var depot_avail: int = int(_depot.get(t, 0))
		var give: int = int(min(want, depot_avail))
		if give <= 0:
			continue

		u.state_ammunition[t] = int(u.state_ammunition.get(t, 0)) + give
		_depot[t] = depot_avail - give

		if not _pending.has(u.id):
			_pending[u.id] = {}
		var by_unit: Dictionary = _pending[u.id]
		by_unit[t] = int(by_unit.get(t, 0)) + give

	# Apply payload (throughput) deltas
	for t in _sliders_stock.keys():
		var e2: SliderEntry = _sliders_stock.get(t, null) as SliderEntry
		if e2 == null or e2.slider == null:
			continue
		var cur_s: int = e2.base
		var target_s: int = int(e2.slider.value)
		var want_s: int = max(0, target_s - cur_s)
		if want_s <= 0:
			continue

		var depot_avail2: int = int(_depot.get(t, 0))
		var give_s: int = int(min(want_s, depot_avail2))
		if give_s <= 0:
			continue

		u.throughput[t] = int(u.throughput.get(t, 0)) + give_s
		_depot[t] = depot_avail2 - give_s

		if not _pending.has(u.id):
			_pending[u.id] = {}
		var by_unit2: Dictionary = _pending[u.id]
		var key := "stock:%s" % [str(t)]
		by_unit2[key] = int(by_unit2.get(key, 0)) + give_s

	_refresh_units()
	_update_depot_label()
	emit_signal("rearm_committed")
	_pending.clear()
```
