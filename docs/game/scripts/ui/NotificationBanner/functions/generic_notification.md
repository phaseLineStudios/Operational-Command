# NotificationBanner::generic_notification Function Reference

*Defined at:* `scripts/ui/NotificationBanner.gd` (lines 65–68)</br>
*Belongs to:* [NotificationBanner](../../NotificationBanner.md)

**Signature**

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play notification sound (default true).

## Description

Show a normal notification with gray background.

## Source

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.NORMAL, sound)
```
