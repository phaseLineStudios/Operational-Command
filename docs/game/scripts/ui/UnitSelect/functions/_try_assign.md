# UnitSelect::_try_assign Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 221–268)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _try_assign(slot_id: String, unit: UnitData) -> void
```

## Description

Attempt to assign a unit to a slot with validation

## Source

```gdscript
func _try_assign(slot_id: String, unit: UnitData) -> void:
	if not _slot_data.has(slot_id):
		return
	var slot: Variant = _slot_data[slot_id]

	# Validate: empty
	if not String(slot["assigned"]).is_empty():
		_slots_list.flash_denied(slot_id)
		return

	# Validate: role
	var allowed: Array = slot["allowed_roles"]
	var role := unit.role
	if not allowed.has(role):
		_slots_list.flash_denied(slot_id)
		return

	# Validate: points
	var cost := unit.cost
	if _used_points + cost > _total_points:
		_slots_list.flash_denied(slot_id)
		return

	# Validate: unit unique
	if _assigned_by_unit.has(unit.id):
		_slots_list.flash_denied(slot_id)
		return

	# Apply
	slot["assigned"] = unit.id
	_slot_data[slot_id] = slot
	_assigned_by_unit[unit.id] = slot_id
	_used_points += cost

	# Hide card in pool
	if _cards_by_unit.has(unit.id):
		var c: UnitCard = _cards_by_unit[unit.id]
		if is_instance_valid(c):
			c.visible = false

	_slots_list.set_assignment(slot_id, unit)
	_refresh_topbar()
	_refresh_pool_filter()
	_recompute_logistics()
	_update_deploy_enabled()
	_on_card_selected(unit)
```
