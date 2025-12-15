# NotificationBanner::failed_notification Function Reference

*Defined at:* `scripts/ui/NotificationBanner.gd` (lines 57–60)</br>
*Belongs to:* [NotificationBanner](../../NotificationBanner.md)

**Signature**

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play failure sound (default true).

## Description

Show a failure notification with red background.

## Source

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.FAILURE, sound)
```
