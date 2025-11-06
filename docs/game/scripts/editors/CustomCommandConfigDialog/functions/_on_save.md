# CustomCommandConfigDialog::_on_save Function Reference

*Defined at:* `scripts/editors/CustomCommandConfigDialog.gd` (lines 46–86)</br>
*Belongs to:* [CustomCommandConfigDialog](../../CustomCommandConfigDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Source

```gdscript
func _on_save() -> void:
	if (
		editor == null
		or command_index < 0
		or command_index >= editor.ctx.data.custom_commands.size()
	):
		return
	var live: CustomCommand = editor.ctx.data.custom_commands[command_index]

	var after := live.duplicate(true)
	after.keyword = cmd_keyword.text.strip_edges()
	after.trigger_id = cmd_trigger_id.text.strip_edges()
	after.route_as_order = cmd_route_as_order.button_pressed

	# Parse grammar text (one word/phrase per line)
	var grammar_text := cmd_grammar.text.strip_edges()
	var lines := grammar_text.split("\n", false)
	var grammar_arr: Array[String] = []
	for line in lines:
		var trimmed := line.strip_edges()
		if trimmed != "":
			grammar_arr.append(trimmed)
	after.additional_grammar = grammar_arr

	if editor.history:
		var desc := "Edit Custom Command: %s" % after.keyword
		# Duplicate entire array, replace item, then push array replacement
		var before_arr := editor.ctx.data.custom_commands.duplicate(true)
		var after_arr := before_arr.duplicate(true)
		after_arr[command_index] = after
		editor.history.push_array_replace(
			editor.ctx.data, "custom_commands", before_arr, after_arr, desc
		)
	else:
		live.keyword = after.keyword
		live.trigger_id = after.trigger_id
		live.route_as_order = after.route_as_order
		live.additional_grammar = after.additional_grammar

	emit_signal("saved", command_index, after)
	visible = false
```
