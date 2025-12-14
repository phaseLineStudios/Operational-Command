# UnitCreateDialog::_populate_type Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 342–347)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _populate_type() -> void
```

## Source

```gdscript
func _populate_type() -> void:
	_type_ob.clear()
	for type in MilSymbol.UnitType.keys():
		_type_ob.add_item(type)
```
