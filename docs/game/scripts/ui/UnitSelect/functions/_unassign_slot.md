# UnitSelect::_unassign_slot Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 305–335)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _unassign_slot(slot_id: String) -> void
```

## Description

Unassign a unit from the given slot

## Source

```gdscript
func _unassign_slot(slot_id: String) -> void:
	if not _slot_data.has(slot_id):
		return
	var slot: Variant = _slot_data[slot_id]
	var unit_id: StringName = slot["assigned"]
	if unit_id.is_empty():
		return

	# Refund points
	var u: UnitData = _units_by_id[unit_id]
	_used_points -= int(u.cost)
	_used_points = max(_used_points, 0)

	# Clear maps
	_assigned_by_unit.erase(unit_id)
	slot["assigned"] = ""
	_slot_data[slot_id] = slot

	# Show card back in pool
	if _cards_by_unit.has(unit_id):
		var c: UnitCard = _cards_by_unit[unit_id]
		if is_instance_valid(c):
			c.visible = true

	_slots_list.clear_assignment(slot_id)
	_refresh_topbar()
	_refresh_pool_filter()
	_recompute_logistics()
	_update_deploy_enabled()
```
