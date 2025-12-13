# MainMenu::_on_editor_pressed Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 169–175)</br>
*Belongs to:* [MainMenu](../../MainMenu.md)

**Signature**

```gdscript
func _on_editor_pressed() -> void
```

## Description

Toggle handler for the Editor button.

## Source

```gdscript
func _on_editor_pressed() -> void:
	if _state == SubmenuState.COLLAPSED:
		_expand_submenu()
	else:
		_collapse_submenu()
```
