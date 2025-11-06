# CustomCommandConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/CustomCommandConfigDialog.gd` (lines 29–45)</br>
*Belongs to:* [CustomCommandConfigDialog](../../CustomCommandConfigDialog.md)

**Signature**

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

- **_editor**: ScenarioEditor instance.
- **index**: Index of the command in `member ScenarioData.custom_commands`.

## Description

Show dialog for editing a custom command at the specified index.

## Source

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void:
	if _editor == null or index < 0 or index >= _editor.ctx.data.custom_commands.size():
		return
	editor = _editor
	command_index = index

	var cmd: CustomCommand = editor.ctx.data.custom_commands[command_index]
	_before = cmd.duplicate(true)

	cmd_keyword.text = cmd.keyword
	cmd_trigger_id.text = cmd.trigger_id
	cmd_route_as_order.button_pressed = cmd.route_as_order
	cmd_grammar.text = "\n".join(cmd.additional_grammar)

	visible = true
```

## References

- [`member ScenarioData.custom_commands`](../../../data/ScenarioData.md#custom_commands)
