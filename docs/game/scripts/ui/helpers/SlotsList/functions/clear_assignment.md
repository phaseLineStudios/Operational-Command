# SlotsList::clear_assignment Function Reference

*Defined at:* `scripts/ui/helpers/SlotsList.gd` (lines 53–58)</br>
*Belongs to:* [SlotsList](../SlotsList.md)

**Signature**

```gdscript
func clear_assignment(slot_id: String) -> void
```

## Description

Clear the assigned unit from a specific SlotItem by slot_id.

## Source

```gdscript
func clear_assignment(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item:
		item.clear_assignment()
```
