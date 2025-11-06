# UnitCreateDialog::_load_ammo_from_working Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 193–212)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _load_ammo_from_working() -> void
```

## Description

Load ammo amounts from _working.ammo into the SpinBoxes.

## Source

```gdscript
func _load_ammo_from_working() -> void:
	var ammo_dict: Variant = _working.get("ammo")
	if typeof(ammo_dict) != TYPE_DICTIONARY:
		ammo_dict = {}

	for i in _ammo_spinners.size():
		var key_name := _ammo_keys[i]
		var sp := _ammo_spinners[i]
		var v := 0

		if ammo_dict.has(key_name):
			v = int(ammo_dict[key_name])
		else:
			var idx := int(UnitData.AmmoTypes[key_name])
			if ammo_dict.has(idx):
				v = int(ammo_dict[idx])

		sp.value = v
```
