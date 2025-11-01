class_name TriggerConfigDialog
extends Window
## Config dialog for ScenarioTrigger.

## Emitted when config is saved.
signal saved(index: int, trigger: ScenarioTrigger)

const CODE_AUTOCOMPLETE := preload("res://scripts/ui/CodeEditAutocomplete.gd")

var editor: ScenarioEditor
var trigger_index := -1
var _before: ScenarioTrigger
var _autocomplete_condition: CodeEditAutocomplete
var _autocomplete_activate: CodeEditAutocomplete
var _autocomplete_deactivate: CodeEditAutocomplete

@onready var save_btn: Button = %Save
@onready var close_btn: Button = %Close
@onready var trig_id: LineEdit = %Id
@onready var trig_title: LineEdit = %Title
@onready var pos_x_in: SpinBox = %PositionX
@onready var pos_y_in: SpinBox = %PositionY
@onready var trig_shape: OptionButton = %Shape
@onready var trig_size_x: SpinBox = %SizeX
@onready var trig_size_y: SpinBox = %SizeY
@onready var trig_duration: SpinBox = %Duration
@onready var trig_presence: OptionButton = %Presence
@onready var run_once: CheckBox = %RunOnce
@onready var trig_condition: CodeEdit = %Condition
@onready var trig_on_activate: CodeEdit = %OnActivate
@onready var trig_on_deactivate: CodeEdit = %OnDeactivate


func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)

	# Setup autocomplete for all code editors
	_setup_autocomplete()


func _exit_tree() -> void:
	# Cleanup autocomplete helpers
	if _autocomplete_condition:
		_autocomplete_condition.detach()
	if _autocomplete_activate:
		_autocomplete_activate.detach()
	if _autocomplete_deactivate:
		_autocomplete_deactivate.detach()


func show_for(_editor: ScenarioEditor, index: int) -> void:
	if _editor == null or index < 0 or index >= _editor.ctx.data.triggers.size():
		return
	editor = _editor
	trigger_index = index

	var trig: ScenarioTrigger = editor.ctx.data.triggers[trigger_index]
	_before = trig.duplicate(true)

	trig_id.text = trig.id
	trig_title.text = trig.title
	pos_x_in.value = trig.area_center_m.x
	pos_y_in.value = trig.area_center_m.y
	trig_presence.clear()
	for i in ScenarioTrigger.PresenceMode.size():
		trig_presence.add_item(str(ScenarioTrigger.PresenceMode.keys()[i]).capitalize(), i)
	trig_presence.select(int(trig.presence))
	trig_shape.clear()
	for i in ScenarioTrigger.AreaShape.size():
		trig_shape.add_item(str(ScenarioTrigger.AreaShape.keys()[i]).capitalize(), i)
	trig_shape.select(int(trig.area_shape))
	trig_size_x.value = trig.area_size_m.x
	trig_size_y.value = trig.area_size_m.y
	trig_duration.value = trig.require_duration_s
	run_once.set_pressed_no_signal(trig.run_once)
	trig_condition.text = trig.condition_expr
	trig_on_activate.text = trig.on_activate_expr
	trig_on_deactivate.text = trig.on_deactivate_expr

	popup_centered_ratio(0.35)


func _on_save() -> void:
	if editor == null or trigger_index < 0 or trigger_index >= editor.ctx.data.triggers.size():
		return
	var live: ScenarioTrigger = editor.ctx.data.triggers[trigger_index]

	var after := live.duplicate(true)
	after.id = trig_id.text
	after.title = trig_title.text
	after.area_center_m = Vector2(pos_x_in.value, pos_y_in.value)
	after.area_shape = trig_shape.get_selected_id() as ScenarioTrigger.AreaShape
	after.area_size_m = Vector2(trig_size_x.value, trig_size_y.value)
	after.require_duration_s = trig_duration.value
	after.presence = trig_presence.get_selected_id() as ScenarioTrigger.PresenceMode
	after.run_once = run_once.button_pressed
	after.condition_expr = trig_condition.text
	after.on_activate_expr = trig_on_activate.text
	after.on_deactivate_expr = trig_on_deactivate.text

	if editor.history:
		var desc := "Edit Trigger %s" % String(_before.id)
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "triggers", "id", String(live.id), _before, after, desc
		)
	else:
		live.id = after.id
		live.title = after.title
		live.area_shape = after.area_shape
		live.area_size_m = after.area_size_m
		live.require_duration_s = after.require_duration_s
		live.presence = after.presence
		live.run_once = after.run_once
		live.condition_expr = after.condition_expr
		live.on_activate_expr = after.on_activate_expr
		live.on_deactivate_expr = after.on_deactivate_expr

	emit_signal("saved", trigger_index, after)
	visible = false
	editor.ctx.request_overlay_redraw()


## Setup autocomplete for all code editors with TriggerAPI methods.
func _setup_autocomplete() -> void:
	# Define TriggerAPI methods for autocomplete
	var trigger_api_methods := {
		"time_s":
		{
			"return_type": "float",
			"description": "Return mission time in seconds.",
			"params": [],
		},
		"is_paused":
		{
			"return_type": "bool",
			"description": "Check if simulation is paused.",
			"params": [],
		},
		"is_running":
		{
			"return_type": "bool",
			"description": "Check if simulation is running.",
			"params": [],
		},
		"time_scale":
		{
			"return_type": "float",
			"description": "Get current time scale (1.0 = normal, 2.0 = 2x speed).",
			"params": [],
		},
		"sim_state":
		{
			"return_type": "String",
			"description": 'Get simulation state ("INIT", "RUNNING", "PAUSED", "COMPLETED").',
			"params": [],
		},
		"radio":
		{
			"return_type": "void",
			"description": "Send a radio/log message (levels: info|warn|error).",
			"params": ["msg: String", 'level: String = "info"'],
		},
		"complete_objective":
		{
			"return_type": "void",
			"description": "Set objective state to completed.",
			"params": ["id: StringName"],
		},
		"fail_objective":
		{
			"return_type": "void",
			"description": "Set objective state to failed.",
			"params": ["id: StringName"],
		},
		"set_objective":
		{
			"return_type": "void",
			"description": "Set objective state to a specific value.",
			"params": ["id: StringName", "state: int"],
		},
		"objective_state":
		{
			"return_type": "int",
			"description": "Get current objective state.",
			"params": ["id: StringName"],
		},
		"unit":
		{
			"return_type": "Dictionary",
			"description":
			(
				"Get minimal snapshot of a unit by id or callsign. "
				+ "Returns {id, callsign, pos_m: Vector2, aff: int} or {}."
			),
			"params": ["id_or_callsign: String"],
		},
		"count_in_area":
		{
			"return_type": "int",
			"description":
			'Count units in an area by affiliation: "friend"|"enemy"|"player"|"any".',
			"params":
			[
				"affiliation: String",
				"center_m: Vector2",
				"size_m: Vector2",
				'shape: String = "rect"'
			],
		},
		"units_in_area":
		{
			"return_type": "Array",
			"description": "Return an Array of unit snapshots in an area.",
			"params":
			[
				"affiliation: String",
				"center_m: Vector2",
				"size_m: Vector2",
				'shape: String = "rect"'
			],
		},
		"last_radio_command":
		{
			"return_type": "String",
			"description": "Get the last radio command heard this tick (cleared after tick).",
			"params": [],
		},
		"get_global":
		{
			"return_type": "Variant",
			"description": "Get a global variable shared across all triggers.",
			"params": ["key: String", "default: Variant = null"],
		},
		"set_global":
		{
			"return_type": "void",
			"description": "Set a global variable shared across all triggers.",
			"params": ["key: String", "value: Variant"],
		},
		"has_global":
		{
			"return_type": "bool",
			"description": "Check if a global variable exists.",
			"params": ["key: String"],
		},
		"show_dialog":
		{
			"return_type": "void",
			"description":
			"Show a mission dialog with text and an OK button. Optionally pauses the simulation.",
			"params":
			[
				"text: String",
				"pause_game: bool = false",
				"position_m: Variant = null",
				"block: bool = false"
			],
		},
		"tutorial_dialog":
		{
			"return_type": "void",
			"description":
			"Show a tutorial dialog pointing at a UI element. Automatically pauses and blocks execution.",
			"params": ["text: String", 'node_identifier: String = ""', "block: bool = true"],
		},
		"has_drawn":
		{
			"return_type": "bool",
			"description": "Check if the player has drawn anything on the map.",
			"params": [],
		},
		"get_drawing_count":
		{
			"return_type": "int",
			"description": "Get the number of drawing strokes the player has made.",
			"params": [],
		},
		"has_created_counter":
		{
			"return_type": "bool",
			"description": "Check if the player has created any unit counters.",
			"params": [],
		},
		"get_counter_count":
		{
			"return_type": "int",
			"description": "Get the number of unit counters the player has created.",
			"params": [],
		},
		"is_unit_in_combat":
		{
			"return_type": "bool",
			"description": "Check if a unit is currently in combat (has spotted enemies).",
			"params": ["id_or_callsign: String"],
		},
		"get_unit_position":
		{
			"return_type": "Variant",
			"description": "Get the current position of a unit in terrain meters (Vector2).",
			"params": ["id_or_callsign: String"],
		},
		"get_unit_grid":
		{
			"return_type": "String",
			"description": 'Get the current grid position of a unit (e.g., "630852").',
			"params": ["id_or_callsign: String", "digits: int = 6"],
		},
		"is_unit_destroyed":
		{
			"return_type": "bool",
			"description": "Check if a unit is destroyed (wiped out, state_strength == 0).",
			"params": ["id_or_callsign: String"],
		},
		"get_unit_strength":
		{
			"return_type": "float",
			"description": "Get the current strength of a unit (base strength × state_strength).",
			"params": ["id_or_callsign: String"],
		},
		"has_built_bridge":
		{
			"return_type": "bool",
			"description": "Check if any engineers have built a bridge.",
			"params": [],
		},
		"get_bridges_built":
		{
			"return_type": "int",
			"description": "Get the number of bridges built by engineers.",
			"params": [],
		},
		"has_called_artillery":
		{
			"return_type": "bool",
			"description": "Check if any artillery fire missions have been called.",
			"params": [],
		},
		"get_artillery_calls":
		{
			"return_type": "int",
			"description": "Get the number of artillery fire missions called.",
			"params": [],
		},
		"vec2":
		{
			"return_type": "Vector2",
			"description": "Create a Vector2 from x and y coordinates.",
			"params": ["x: float", "y: float"],
		},
		"vec3":
		{
			"return_type": "Vector3",
			"description": "Create a Vector3 from x, y, and z coordinates.",
			"params": ["x: float", "y: float", "z: float"],
		},
		"color":
		{
			"return_type": "Color",
			"description": "Create a Color from RGB or RGBA values (0.0 to 1.0).",
			"params": ["r: float", "g: float", "b: float", "a: float = 1.0"],
		},
		"rect2":
		{
			"return_type": "Rect2",
			"description": "Create a Rect2 from position and size.",
			"params": ["x: float", "y: float", "width: float", "height: float"],
		},
		"sleep":
		{
			"return_type": "void",
			"description":
			"Pause execution for a duration (mission time). Pausing the game pauses the sleep timer.",
			"params": ["duration_s: float"],
		},
		"sleep_ui":
		{
			"return_type": "void",
			"description":
			"Pause execution for a duration (real-time). Continues even when game is paused.",
			"params": ["duration_s: float"],
		},
	}

	# Create and setup autocomplete for condition
	_autocomplete_condition = CODE_AUTOCOMPLETE.new()
	_autocomplete_condition.add_methods(trigger_api_methods)
	_autocomplete_condition.attach(trig_condition)

	# Create and setup autocomplete for on_activate
	_autocomplete_activate = CODE_AUTOCOMPLETE.new()
	_autocomplete_activate.add_methods(trigger_api_methods)
	_autocomplete_activate.attach(trig_on_activate)

	# Create and setup autocomplete for on_deactivate
	_autocomplete_deactivate = CODE_AUTOCOMPLETE.new()
	_autocomplete_deactivate.add_methods(trigger_api_methods)
	_autocomplete_deactivate.attach(trig_on_deactivate)
