# LoadingScreen::set_loading_message Function Reference

*Defined at:* `scripts/ui/LoadingScreen.gd` (lines 31–35)</br>
*Belongs to:* [LoadingScreen](../../LoadingScreen.md)

**Signature**

```gdscript
func set_loading_message(message: String) -> void
```

## Description

Set the loading screen message

## Source

```gdscript
func set_loading_message(message: String) -> void:
	if _label:
		_label.text = message
```
