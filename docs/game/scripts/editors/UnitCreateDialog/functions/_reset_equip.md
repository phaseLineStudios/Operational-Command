# UnitCreateDialog::_reset_equip Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 657–662)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _reset_equip() -> void
```

## Description

Reset equipment dictionary.

## Source

```gdscript
func _reset_equip() -> void:
	_equip.clear()
	for cat in UnitData.EquipCategory.keys():
		_equip[cat.to_lower()] = {}
```
