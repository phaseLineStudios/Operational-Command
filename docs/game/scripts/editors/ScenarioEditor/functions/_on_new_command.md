# ScenarioEditor::_on_new_command Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 626–646)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_new_command() -> void
```

## Description

Create a new custom command

## Source

```gdscript
func _on_new_command() -> void:
	if not ctx.data:
		return
	var cmd := CustomCommand.new()
	cmd.keyword = "new_command"

	if history:
		var before := ctx.data.custom_commands.duplicate(true)
		var after := before.duplicate(true)
		after.append(cmd)
		history.push_array_replace(ctx.data, "custom_commands", before, after, "Add Custom Command")
	else:
		ctx.data.custom_commands.append(cmd)

	_rebuild_command_list()
	# Select and open the new command
	var idx := ctx.data.custom_commands.size() - 1
	command_list.select(idx)
	menus.open_command_config(idx)
```
