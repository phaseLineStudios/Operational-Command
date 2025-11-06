# UnitDDItemList::_drop_data Function Reference

*Defined at:* `scripts/editors/helpers/UnitDDItemList.gd` (lines 46–50)</br>
*Belongs to:* [UnitDDItemList](../../UnitDDItemList.md)

**Signature**

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void
```

## Description

Notify dialog to move the unit.

## Source

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void:
	if not _can_drop_data(_pos, data):
		return
	if _dlg and _dlg.has_method("_on_unit_dropped"):
		_dlg._on_unit_dropped(int(data.get("from", int(kind))), int(kind), String(data.get("id")))
```
