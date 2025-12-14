# UnitCreateDialog::_on_add_equip Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 477–496)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_add_equip() -> void
```

## Description

Add equipment to list.

## Source

```gdscript
func _on_add_equip() -> void:
	var c := _equip_cat.selected as UnitData.EquipCategory
	var c_str := UnitData.EquipCategory.keys()[c] as String
	var k := _equip_key.text.strip_edges()
	var v := int(_equip_val.value)
	var a: int = -1
	if c == UnitData.EquipCategory.WEAPONS:
		a = _equip_ammo.selected as UnitData.AmmoTypes
	if k == "":
		return
	if _equip[c_str.to_lower()].has(k):
		_replace_kv_row(_equip_list, k, v, c_str.to_lower(), a)
	else:
		_add_kv_row(_equip_list, k, v, _on_delete_equip_row, c_str.to_lower(), a)
	_equip[c_str.to_lower()][k] = {"type": v, "ammo": a}
	_equip_key.text = ""
	_equip_val.value = 0
	_update_attack_preview()
```
