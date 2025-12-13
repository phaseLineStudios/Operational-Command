# UnitSelect::_on_request_assign_drop Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 240–249)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _on_request_assign_drop(slot_id: String, unit: UnitData, source_slot_id: String) -> void
```

## Description

Called when a slot requests to assign a unit

## Source

```gdscript
func _on_request_assign_drop(slot_id: String, unit: UnitData, source_slot_id: String) -> void:
	# Move from another slot if needed
	if not source_slot_id.is_empty():
		if source_slot_id == slot_id:
			return
		_unassign_slot(source_slot_id)

	_try_assign(slot_id, unit)
```
