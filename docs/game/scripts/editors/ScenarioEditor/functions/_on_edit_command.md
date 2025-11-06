# ScenarioEditor::_on_edit_command Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 648–654)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_edit_command() -> void
```

## Description

Edit the selected custom command

## Source

```gdscript
func _on_edit_command() -> void:
	var selected := command_list.get_selected_items()
	if selected.is_empty():
		return
	menus.open_command_config(selected[0])
```
