# MainMenu::_collapse_submenu Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 177–181)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _collapse_submenu() -> void
```

## Description

Collapse the submenu.

## Source

```gdscript
func _collapse_submenu() -> void:
	_submenu_holder.visible = false
	_state = SubmenuState.COLLAPSED
```
