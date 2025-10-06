# SlotItem::_can_drop_data Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 149–167)</br>
*Belongs to:* [SlotItem](../SlotItem.md)

**Signature**

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool
```

## Description

Validate payload type and role compatibility for dropping onto this slot.

## Source

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	var ok: bool = typeof(data) == TYPE_DICTIONARY and data.has("type")
	if not ok:
		_deny_hover = false
		_apply_style()
		return false
	var t := String(data["type"])
	var is_valid_type := t == "unit" or t == "assigned_unit"
	if not is_valid_type:
		_deny_hover = false
		_apply_style()
		return false
	var unit: UnitData = data.get("unit", {})
	var can := allowed_roles.has(String(unit.role))
	_deny_hover = not can
	_apply_style()
	return can
```
