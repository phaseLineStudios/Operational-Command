# UnitCreateDialog::_ready Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 68–100)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_populate_type()
	_populate_size()
	_populate_move_profile()
	_populate_categories()
	_populate_ammo()

	for cat in UnitData.EquipCategory.keys():
		_equip_cat.add_item(cat)

	for ammo in UnitData.AmmoTypes.keys():
		_equip_ammo.add_item(ammo)

	_equip_cat.item_selected.connect(
		func(idx: int):
			if idx == UnitData.EquipCategory.WEAPONS:
				_equip_ammo_container.visible = true
			else:
				_equip_ammo_container.visible = false
	)

	_slot_add.pressed.connect(_on_add_slot)
	_equip_add.pressed.connect(_on_add_equip)
	_th_add.pressed.connect(_on_add_throughput)

	_save_btn.pressed.connect(_on_save_pressed)
	_cancel_btn.pressed.connect(_on_cancel_pressed)
	close_requested.connect(_on_cancel_pressed)

	_size_ob.item_selected.connect(_generate_preview_icons)
	_type_ob.item_selected.connect(_generate_preview_icons)
```
