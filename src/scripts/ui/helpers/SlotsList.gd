extends VBoxContainer
class_name SlotsList
## Container for SlotItem panels.
## Builds one SlotItem per mission slot instance and relays signals upward.

## @experimental

signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
signal request_inspect_unit(unit: Dictionary)

var _items_by_slot: Dictionary = {} ## slot_id -> SlotItem

func build_from_slots(slots: Dictionary) -> void:
	# slots: { slot_id: { key,title,allowed_roles,index,max,assigned:StringName("") } }
	_items_by_slot.clear()
	for c in get_children():
		c.queue_free()

	# Stable sorted by slot_id for consistency
	var keys := slots.keys()
	keys.sort()

	for sid in keys:
		var meta: Dictionary = slots[sid]
		var item := SlotItem.new()
		item.configure(sid, String(meta["title"]), meta["allowed_roles"], int(meta["index"]), int(meta["max"]))
		item.request_assign_drop.connect(func(slot_id, unit, source_sid): emit_signal("request_assign_drop", slot_id, unit, source_sid))
		item.request_inspect_unit.connect(func(unit): emit_signal("request_inspect_unit", unit))
		item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(item)
		_items_by_slot[sid] = item

func set_assignment(slot_id: String, unit: Dictionary) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item:
		item.set_assignment(unit)

func clear_assignment(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item:
		item.clear_assignment()

func flash_denied(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if not item: return
	item.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(0.15).timeout
	if is_instance_valid(item):
		item.modulate = Color(1, 1, 1)
