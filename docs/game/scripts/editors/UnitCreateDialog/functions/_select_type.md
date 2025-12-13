# UnitCreateDialog::_select_type Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 413–420)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _select_type(v: int) -> void
```

## Description

Select unit type.

## Source

```gdscript
func _select_type(v: int) -> void:
	for i in _type_ob.item_count:
		if _type_ob.get_item_id(i) == int(v):
			_type_ob.select(i)
			_generate_preview_icons(-1)
			return
```
