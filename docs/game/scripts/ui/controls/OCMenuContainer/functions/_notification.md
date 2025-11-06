# OCMenuContainer::_notification Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContainer.gd` (lines 73–77)</br>
*Belongs to:* [OCMenuContainer](../../OCMenuContainer.md)

**Signature**

```gdscript
func _notification(what: int) -> void
```

## Source

```gdscript
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
```
