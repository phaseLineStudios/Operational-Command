# UnitCreateDialog::_collect_ammo_into_working Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 246–253)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _collect_ammo_into_working() -> void
```

## Description

Collect ammo amounts from SpinBoxes into _working.ammo.

## Source

```gdscript
func _collect_ammo_into_working() -> void:
	var out := {}
	for i in _ammo_spinners.size():
		var val := int(_ammo_spinners[i].value)
		out[_ammo_keys[i]] = val
	_working.ammunition = out
```
