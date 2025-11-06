# UnitCreateDialog::_collect_into_working Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 214–244)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _collect_into_working() -> void
```

## Description

Apply UI -> working data.

## Source

```gdscript
func _collect_into_working() -> void:
	_working.id = _require_id(_id.text)
	_working.title = _title.text.strip_edges()
	_working.role = _role.text.strip_edges()
	_working.cost = int(_cost.value)
	_working.strength = int(_strength.value)
	_working.state_strength = int(_strength.value)
	_working.attack = float(_attack.value)
	_working.defense = float(_defense.value)
	_working.spot_m = float(_spot_m.value)
	_working.range_m = float(_range_m.value)
	_working.morale = clamp(float(_morale.value), 0.0, 1.0)
	_working.speed_kph = float(_speed_kph.value)
	_working.is_engineer = _is_engineer.button_pressed
	_working.is_medical = _is_medical.button_pressed

	_working.type = int(_type_ob.get_selected_id()) as MilSymbol.UnitType
	_working.size = int(_size_ob.get_selected_id()) as MilSymbol.UnitSize
	_working.movement_profile = int(_move_ob.get_selected_id()) as TerrainBrush.MoveProfile

	_working.allowed_slots = _slots.duplicate()
	_working.equipment = _equip.duplicate()
	_working.throughput = _thru.duplicate()

	_collect_ammo_into_working()

	var cat_meta = _category_ob.get_item_metadata(_category_ob.get_selected())
	if typeof(cat_meta) == TYPE_DICTIONARY and cat_meta.has("res"):
		_working.unit_category = cat_meta["res"]
```
