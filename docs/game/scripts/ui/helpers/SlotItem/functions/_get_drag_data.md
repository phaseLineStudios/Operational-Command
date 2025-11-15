# SlotItem::_get_drag_data Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 183–191)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant
```

## Description

When filled, allow dragging the assigned unit out to pool or another slot.

## Source

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant:
	if _assigned_unit == null:
		return null
	var p := Label.new()
	p.text = _assigned_unit.title
	set_drag_preview(p)
	return {"type": "assigned_unit", "unit": _assigned_unit, "slot_id": slot_id}
```
