# PauseMenu::_on_setting_hide Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 90–94)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_setting_hide() -> void
```

## Description

called on settings back requested.

## Source

```gdscript
func _on_setting_hide() -> void:
	settings.set_visibility(false)
	menu_container.visible = true
```
