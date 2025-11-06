class_name PoolDropArea
extends VBoxContainer
## Vertical list that can live directly in a ScrollContainer.

signal request_return_to_pool(slot_id: String, unit: UnitData)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	return String(data.get("type", "")) == "assigned_unit"


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not _can_drop_data(_at_position, data):
		return
	var unit: UnitData = data.get("unit", {})
	var slot_id := String(data.get("slot_id", ""))
	emit_signal("request_return_to_pool", slot_id, unit)
