# UnitSelect::_on_request_return_to_pool Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 300–303)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _on_request_return_to_pool(slot_id: String, _unit: UnitData) -> void
```

## Description

Called when a slot unit is returned to pool

## Source

```gdscript
func _on_request_return_to_pool(slot_id: String, _unit: UnitData) -> void:
	_unassign_slot(slot_id)
```
