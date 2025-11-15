# SlotItem::_drop_data Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 174–181)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void
```

## Description

Emit assignment request for valid drops, else briefly flash deny.

## Source

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void:
	if not _can_drop_data(_pos, data):
		return
	var unit: UnitData = data["unit"]
	var source_sid := String(data.get("slot_id", ""))
	emit_signal("request_assign_drop", slot_id, unit, source_sid)
```
