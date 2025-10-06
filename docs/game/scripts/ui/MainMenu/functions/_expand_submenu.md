# MainMenu::_expand_submenu Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 171–175)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _expand_submenu() -> void
```

## Description

Expand the submenu below the Editor button.

## Source

```gdscript
func _expand_submenu() -> void:
	_submenu_holder.visible = true
	_state = SubmenuState.EXPANDED
```
