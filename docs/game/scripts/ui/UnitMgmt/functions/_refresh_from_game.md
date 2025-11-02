# UnitMgmt::_refresh_from_game Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 29–58)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _refresh_from_game() -> void
```

## Description

Pull units from Game and refresh list and panel.

## Source

```gdscript
func _refresh_from_game() -> void:
	_units = _collect_units_from_game()
	_uid_to_index.clear()

	# Rebuild list with title + strength badge per row
	for c in _list_box.get_children():
		c.queue_free()

	var idx := 0
	for u: UnitData in _units:
		_uid_to_index[u.id] = idx
		idx += 1

		var row := HBoxContainer.new()
		_list_box.add_child(row)

		var title := Label.new()
		title.text = u.title
		row.add_child(title)

		var badge: UnitStrengthBadge = UnitStrengthBadge.new()
		# Pass per-unit threshold if set; fall back to panel default inside the badge
		badge.set_unit(u, _panel.understrength_threshold)
		row.add_child(badge)

	# Keep panel updated
	_panel.set_units(_units)
	_panel.set_pool(_get_pool())
```
