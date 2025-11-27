# UnitCreateDialog::_gather_ammo_from_inputs Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 263–269)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _gather_ammo_from_inputs() -> Dictionary
```

## Source

```gdscript
func _gather_ammo_from_inputs() -> Dictionary:
	var out := {}
	for i in _ammo_spinners.size():
		out[_ammo_keys[i]] = int(_ammo_spinners[i].value)
	return out
```
