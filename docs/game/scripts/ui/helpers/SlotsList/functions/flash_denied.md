# SlotsList::flash_denied Function Reference

*Defined at:* `scripts/ui/helpers/SlotsList.gd` (lines 60–67)</br>
*Belongs to:* [SlotsList](../../SlotsList.md)

**Signature**

```gdscript
func flash_denied(slot_id: String) -> void
```

## Description

Briefly tint a SlotItem to indicate a denied action.

## Source

```gdscript
func flash_denied(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if not item:
		return
	item.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(DENY_FLASH_TIME).timeout
	if is_instance_valid(item):
		item.modulate = Color(1, 1, 1)
```
