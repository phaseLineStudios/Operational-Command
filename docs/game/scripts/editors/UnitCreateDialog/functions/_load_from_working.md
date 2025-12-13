# UnitCreateDialog::_load_from_working Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 131–205)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _load_from_working() -> void
```

## Description

Load UI from working data.

## Source

```gdscript
func _load_from_working() -> void:
	if _mode == DialogMode.CREATE:
		if String(_working.role) == "":
			_working.role = "INF"
		if _working.allowed_slots.is_empty():
			_working.allowed_slots = ["INF"]
		if _working.size == null:
			_working.size = MilSymbol.UnitSize.PLATOON
		if _working.morale == 0.0:
			_working.morale = 0.9
		if _working.movement_profile == null:
			_working.movement_profile = _default_move_profile() as TerrainBrush.MoveProfile

	_id.text = String(_working.id)
	_title.text = String(_working.title)
	_role.text = String(_working.role)
	_cost.value = _working.cost
	_strength.value = _working.strength
	_defense.value = _working.defense
	_spot_m.value = _working.spot_m
	_range_m.value = _working.range_m
	_morale.value = _working.morale
	_speed_kph.value = _working.speed_kph
	_is_engineer.set_pressed_no_signal(_working.is_engineer)
	_is_medical.set_pressed_no_signal(_working.is_medical)

	_select_size(_working.size)
	_select_type(_working.type)
	_select_move_profile(_working.movement_profile)
	_select_category(_working.unit_category)

	_slots.clear()
	for s in _working.allowed_slots:
		_add_slot_row(String(s))
	_slots = _working.allowed_slots.duplicate()

	_reset_equip()
	var eq := _working.equipment if (typeof(_working.equipment) == TYPE_DICTIONARY) else {}
	for raw_cat in eq.keys():
		var cat := String(raw_cat).to_lower()
		if not _equip.has(cat):
			_equip[cat] = {}
		var cat_dict: Variant = eq[raw_cat]
		if typeof(cat_dict) != TYPE_DICTIONARY:
			continue

		for k in cat_dict.keys():
			var entry: Variant = cat_dict[k]
			var count := 0
			var ammo := -1

			if typeof(entry) == TYPE_DICTIONARY:
				if entry.has("type"):
					count = int(entry["type"])
				elif entry.has("count"):
					count = int(entry["count"])
				else:
					count = int(entry)
				if entry.has("ammo"):
					ammo = int(entry["ammo"])
			else:
				count = int(entry)

			_add_kv_row(_equip_list, String(k), count, _on_delete_equip_row, cat, ammo)
			_equip[cat][String(k)] = {"type": count, "ammo": ammo}

	_thru.clear()
	for k in _working.throughput.keys():
		_add_kv_row(_th_list, String(k), _working.throughput[k], _on_delete_throughput_row)
		_thru[k] = _working.throughput[k]

	_load_ammo_from_working()
	_update_attack_preview()
```
