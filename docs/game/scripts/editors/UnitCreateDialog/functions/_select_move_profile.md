# UnitCreateDialog::_select_move_profile Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 392–398)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _select_move_profile(v: int) -> void
```

## Description

Select move profile.

## Source

```gdscript
func _select_move_profile(v: int) -> void:
	for i in _move_ob.item_count:
		if _move_ob.get_item_id(i) == int(v):
			_move_ob.select(i)
			return
```
