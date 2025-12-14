# PauseMenu::_on_setting_show Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 72–76)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_setting_show() -> void
```

## Description

Called on settings button pressed.

## Source

```gdscript
func _on_setting_show() -> void:
	menu_container.visible = false
	settings.set_visibility(true)
```
