# UnitCreateDialog::_populate_size Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 349–355)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _populate_size() -> void
```

## Description

populate size optionbutton.

## Source

```gdscript
func _populate_size() -> void:
	_size_ob.clear()
	for echelon in MilSymbol.UnitSize.keys():
		_size_ob.add_item(echelon)
	_select_size(MilSymbol.UnitSize.PLATOON)
```
