# NotificationBanner::success_notification Function Reference

*Defined at:* `scripts/ui/NotificationBanner.gd` (lines 49–52)</br>
*Belongs to:* [NotificationBanner](../../NotificationBanner.md)

**Signature**

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play success sound (default true).

## Description

Show a success notification with green background.

## Source

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.SUCCESS, sound)
```
