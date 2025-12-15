# ScenarioEditor::failed_notification Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 768–772)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play failure sound (default true).

## Description

Show a failure notification banner.

## Source

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	if _notification_banner:
		_notification_banner.failed_notification(text, timeout, sound)
```
