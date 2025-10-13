# SlotsList::build_from_slots Function Reference

*Defined at:* `scripts/ui/helpers/SlotsList.gd` (lines 23–44)</br>
*Belongs to:* [SlotsList](../../SlotsList.md)

**Signature**

```gdscript
func build_from_slots(slots: Dictionary) -> void
```

## Description

Rebuild child SlotItems from the provided slot metadata map.

## Source

```gdscript
func build_from_slots(slots: Dictionary) -> void:
	_items_by_slot.clear()
	for c in get_children():
		c.queue_free()

	var keys := slots.keys()
	keys.sort()
	for sid in keys:
		var meta: Dictionary = slots[sid]
		var item: SlotItem = slot_item_scene.instantiate() as SlotItem
		add_child(item)
		item.configure(
			sid, String(meta["title"]), meta["allowed_roles"], int(meta["index"]), int(meta["max"])
		)
		item.request_assign_drop.connect(
			func(slot_id, unit, source_sid):
				emit_signal("request_assign_drop", slot_id, unit, source_sid)
		)
		item.request_inspect_unit.connect(func(unit): emit_signal("request_inspect_unit", unit))
		_items_by_slot[sid] = item
```
