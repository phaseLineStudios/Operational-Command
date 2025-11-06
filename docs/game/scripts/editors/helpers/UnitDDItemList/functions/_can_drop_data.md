# UnitDDItemList::_can_drop_data Function Reference

*Defined at:* `scripts/editors/helpers/UnitDDItemList.gd` (lines 41–44)</br>
*Belongs to:* [UnitDDItemList](../../UnitDDItemList.md)

**Signature**

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool
```

## Description

Accept drops that are unit payloads.

## Source

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.get("type", "") == "unit"
```
