# UnitCard::_get_drag_data Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 120–125)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant
```

## Description

Provide drag payload.

## Source

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant:
	var preview := _make_drag_preview()
	set_drag_preview(preview)
	return {"type": "unit", "unit": unit, "unit_id": unit_id}
```
