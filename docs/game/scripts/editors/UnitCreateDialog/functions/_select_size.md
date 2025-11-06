# UnitCreateDialog::_select_size Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 374–381)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _select_size(v: int) -> void
```

## Description

Select unit size.

## Source

```gdscript
func _select_size(v: int) -> void:
	for i in _size_ob.item_count:
		if _size_ob.get_item_id(i) == int(v):
			_size_ob.select(i)
			_generate_preview_icons(-1)
			return
```
