# SlotItem::_notification Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 188–191)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _notification(what: int) -> void
```

## Description

Clear deny-hover at drag end to restore normal styling.

## Source

```gdscript
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		_deny_hover = false
		_apply_style()
```
