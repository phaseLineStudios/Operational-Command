# SlotItem::set_assignment Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 81–87)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func set_assignment(unit: UnitData) -> void
```

## Description

Assign a unit to this slot and refresh visuals.

## Source

```gdscript
func set_assignment(unit: UnitData) -> void:
	_assigned_unit = unit.duplicate(true)
	_refresh_labels()
	_update_icon()
	_apply_style()
```
