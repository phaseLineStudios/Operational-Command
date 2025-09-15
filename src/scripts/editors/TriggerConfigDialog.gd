extends Window
class_name TriggerConfigDialog
## Config dialog for ScenarioTrigger.

signal saved(index: int, trigger: ScenarioTrigger)

@onready var save_btn: Button = %Save
@onready var close_btn: Button = %Close
@onready var trig_title: LineEdit = %Title
@onready var trig_shape: OptionButton = %Shape
@onready var trig_size_x: SpinBox = %SizeX
@onready var trig_size_y: SpinBox = %SizeY
@onready var trig_duration: SpinBox = %Duration
@onready var trig_presence: OptionButton = %Presence
@onready var trig_condition: TextEdit = %Condition
@onready var trig_on_activate: TextEdit = %OnActivate
@onready var trig_on_deactivate: TextEdit = %OnDeactivate

var editor: ScenarioEditor
var trigger_index := -1
var _before: ScenarioTrigger

func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)

func show_for(_editor: ScenarioEditor, index: int) -> void:
	if _editor == null or index < 0 or index >= _editor.data.triggers.size():
		return
	editor = _editor
	trigger_index = index

	var trig: ScenarioTrigger = editor.data.triggers[trigger_index]
	_before = trig.duplicate(true)

	trig_title.text = trig.title
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
	trig_condition.text = trig.condition_expr
	trig_on_activate.text = trig.on_activate_expr
	trig_on_deactivate.text = trig.on_deactivate_expr

	visible = true

func _on_save() -> void:
	if editor == null or trigger_index < 0 or trigger_index >= editor.data.triggers.size(): return
	var live: ScenarioTrigger = editor.data.triggers[trigger_index]

	var after := live.duplicate(true)
	after.title = trig_title.text
	after.area_shape = trig_shape.get_selected_id() as ScenarioTrigger.AreaShape
	after.area_size_m = Vector2(trig_size_x.value, trig_size_y.value)
	after.require_duration_s = trig_duration.value
	after.presence = trig_presence.get_selected_id() as ScenarioTrigger.PresenceMode
	after.condition_expr = trig_condition.text
	after.on_activate_expr = trig_on_activate.text
	after.on_deactivate_expr = trig_on_deactivate.text

	if editor.history:
		var desc := "Edit Trigger %s" % String(_before.id)
		editor.history.push_res_edit_by_id(editor.data, "triggers", "id", String(live.id), _before, after, desc)
	else:
		live.title = after.title
		live.area_shape = after.area_shape
		live.area_size_m = after.area_size_m
		live.require_duration_s = after.require_duration_s
		live.presence = after.presence
		live.condition_expr = after.condition_expr
		live.on_activate_expr = after.on_activate_expr
		live.on_deactivate_expr = after.on_deactivate_expr

	emit_signal("saved", trigger_index, after)
	visible = false
	editor._request_overlay_redraw()
