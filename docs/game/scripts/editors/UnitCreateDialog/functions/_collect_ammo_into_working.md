# UnitCreateDialog::_collect_ammo_into_working Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 258–261)</br>
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
	_working.ammunition = _gather_ammo_from_inputs()
```
