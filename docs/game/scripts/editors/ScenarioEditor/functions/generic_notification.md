# ScenarioEditor::generic_notification Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 777–779)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

- **text**: Notification text to display.
- **timeout**: Duration in seconds before auto-hiding (default 2).
- **sound**: Whether to play notification sound (default true).

## Description

Show a normal notification banner.

## Source

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	if _notification_banner:
		_notification_banner.generic_notification(text, timeout, sound)
```
