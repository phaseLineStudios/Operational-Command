# SlotItem::clear_assignment Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 89–95)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func clear_assignment() -> void
```

## Description

Clear the assigned unit and refresh visuals.

## Source

```gdscript
func clear_assignment() -> void:
	_assigned_unit = null
	_refresh_labels()
	_update_icon()
	_apply_style()
```
