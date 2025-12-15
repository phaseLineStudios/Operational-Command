# ScenarioEditorDeletionOps::delete_command Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 213–227)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_command(command_index: int) -> void
```

- **command_index**: Index of custom command to delete.

## Description

Delete a custom command; push history and refresh.

## Source

```gdscript
func delete_command(command_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.custom_commands:
		return
	if command_index < 0 or command_index >= editor.ctx.data.custom_commands.size():
		return
	var before := editor.ctx.data.custom_commands.duplicate(true)
	var after := editor.ctx.data.custom_commands.duplicate(true)
	after.remove_at(command_index)
	editor.history.push_array_replace(
		editor.ctx.data, "custom_commands", before, after, "Delete Custom Command"
	)
	editor._rebuild_command_list()
	editor.generic_notification("Deleted custom command", 1, false)
```
