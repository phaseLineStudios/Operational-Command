# NotificationBanner::hide_notification Function Reference

*Defined at:* `scripts/ui/NotificationBanner.gd` (lines 103–107)</br>
*Belongs to:* [NotificationBanner](../../NotificationBanner.md)

**Signature**

```gdscript
func hide_notification() -> void
```

## Description

Hide notification (called by timer or manually).

## Source

```gdscript
func hide_notification() -> void:
	visible = false
	_timer.stop()
```
