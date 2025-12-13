# OCMenuButton::_notification Function Reference

*Defined at:* `scripts/ui/controls/OcMenuButton.gd` (lines 64–68)</br>
*Belongs to:* [OCMenuButton](../../OCMenuButton.md)

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
