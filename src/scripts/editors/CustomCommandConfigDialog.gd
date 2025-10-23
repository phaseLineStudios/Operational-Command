class_name CustomCommandConfigDialog
extends Window
## Config dialog for CustomCommand in scenario editor.

## Emitted when custom command is saved.
signal saved(index: int, command: CustomCommand)

var editor: ScenarioEditor
var command_index := -1
var _before: CustomCommand

@onready var save_btn: Button = %Save
@onready var close_btn: Button = %Close
@onready var cmd_keyword: LineEdit = %Keyword
@onready var cmd_trigger_id: LineEdit = %TriggerID
@onready var cmd_route_as_order: CheckBox = %RouteAsOrder
@onready var cmd_grammar: TextEdit = %Grammar


func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)


## Show dialog for editing a custom command at the specified index.
## [param _editor] ScenarioEditor instance.
## [param index] Index of the command in [member ScenarioData.custom_commands].
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


func _on_save() -> void:
	if editor == null or command_index < 0 or command_index >= editor.ctx.data.custom_commands.size():
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
