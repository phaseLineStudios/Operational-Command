extends VBoxContainer
class_name SlotsList
## Container for SlotItem panels.
##
## Builds one SlotItem per mission slot instance and relays signals upward.
## @experimental

## Emitted when a SlotItem requests to assign a unit after a valid drop.
signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
## Emitted when a SlotItem requests to inspect its assigned unit.
signal request_inspect_unit(unit: Dictionary)

## Slot Scene
@export var slot_item_scene: PackedScene 

## Duration (seconds) for the denied flash fallback effect.
const DENY_FLASH_TIME := 0.15

var _items_by_slot: Dictionary = {}

## Rebuild child SlotItems from the provided slot metadata map.
func build_from_slots(slots: Dictionary) -> void:
	_items_by_slot.clear()
	for c in get_children(): c.queue_free()

	var keys := slots.keys(); keys.sort()
	for sid in keys:
		var meta: Dictionary = slots[sid]
		var item: SlotItem = slot_item_scene.instantiate() as SlotItem
		add_child(item)
		item.configure(
			sid,
			String(meta["title"]),
			meta["allowed_roles"],
			int(meta["index"]),
			int(meta["max"])
		)
		item.request_assign_drop.connect(func(slot_id, unit, source_sid):
			emit_signal("request_assign_drop", slot_id, unit, source_sid))
		item.request_inspect_unit.connect(func(unit):
			emit_signal("request_inspect_unit", unit))
		_items_by_slot[sid] = item

## Apply an assigned unit to a specific SlotItem by slot_id.
func set_assignment(slot_id: String, unit: UnitData) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item: 
		item.set_assignment(unit)

## Clear the assigned unit from a specific SlotItem by slot_id.
func clear_assignment(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if item:
		item.clear_assignment()

## Briefly tint a SlotItem to indicate a denied action.
func flash_denied(slot_id: String) -> void:
	var item: SlotItem = _items_by_slot.get(slot_id, null)
	if not item: return
	item.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(DENY_FLASH_TIME).timeout
	if is_instance_valid(item):
		item.modulate = Color(1, 1, 1)
