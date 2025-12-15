# ScenarioEditor::_on_delete_command Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 692–698)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_delete_command() -> void
```

## Description

Delete the selected custom command

## Source

```gdscript
func _on_delete_command() -> void:
	var selected := command_list.get_selected_items()
	if selected.is_empty():
		return
	deletion_ops.delete_command(selected[0])
```
