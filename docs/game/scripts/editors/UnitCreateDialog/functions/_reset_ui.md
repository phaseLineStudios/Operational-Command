# UnitCreateDialog::_reset_ui Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 588–630)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _reset_ui() -> void
```

## Description

Reset UI elements

## Source

```gdscript
func _reset_ui() -> void:
	for le in [_id, _title, _role, _slot_input, _equip_key, _th_key]:
		if le:
			le.text = ""

	for sb in [
		_cost,
		_strength,
		_attack,
		_defense,
		_spot_m,
		_range_m,
		_morale,
		_speed_kph,
		_equip_val,
		_th_val
	]:
		if sb:
			sb.value = 0
	_slots.clear()
	_reset_equip()
	_thru.clear()
	for c in _slots_list.get_children():
		c.queue_free()
	for c in _equip_list.get_children():
		c.queue_free()
	for c in _th_list.get_children():
		c.queue_free()
	if _category_ob.item_count > 0:
		_category_ob.select(-1)
	for sp in _ammo_spinners:
		if sp:
			sp.value = 0
	_select_size(MilSymbol.UnitSize.PLATOON)
	_select_type(MilSymbol.UnitType.INFANTRY)
	_select_move_profile(_default_move_profile())
	_equip_cat.select(UnitData.EquipCategory.VEHICLES)

	_equip_ammo_container.visible = false
	_is_engineer.set_pressed_no_signal(false)
	_is_medical.set_pressed_no_signal(false)
```
