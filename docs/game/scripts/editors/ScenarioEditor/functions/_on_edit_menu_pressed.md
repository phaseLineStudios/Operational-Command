# ScenarioEditor::_on_edit_menu_pressed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 425–436)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_edit_menu_pressed(id: int) -> void
```

- **id**: Menu item ID (0=Undo, 1=Redo).

## Description

Handle Edit menu actions (Undo/Redo).

## Source

```gdscript
func _on_edit_menu_pressed(id: int) -> void:
	match id:
		0:  # Undo
			if history:
				history.undo()
				generic_notification("Undo", 1, false)
		1:  # Redo
			if history:
				history.redo()
				generic_notification("Redo", 1, false)
```
