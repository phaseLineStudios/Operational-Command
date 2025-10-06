# SlotsList::set_assignment Function Reference

*Defined at:* `scripts/ui/helpers/SlotsList.gd` (lines 46–51)</br>
*Belongs to:* [SlotsList](../SlotsList.md)

**Signature**

```gdscript
func set_assignment(slot_id: String, unit: UnitData) -> void
```

## Description

Apply an assigned unit to a specific SlotItem by slot_id.

## Source

```gdscript
func set_assignment(slot_id: String, unit: UnitData) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item:
		item.set_assignment(unit)
```
