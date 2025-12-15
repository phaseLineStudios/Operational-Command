# ScenarioEditor::success_notification Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 759–763)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play success sound (default true).

## Description

Show a success notification banner.

## Source

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	if _notification_banner:
		_notification_banner.success_notification(text, timeout, sound)
```
