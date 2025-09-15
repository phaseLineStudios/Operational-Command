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
	var t: ScenarioTrigger = editor.data.triggers[trigger_index]

	var t_title := trig_title.text
	var shape := trig_shape.get_selected_id()
	var size_x := trig_size_x.value
	var size_y := trig_size_y.value
	var dur := trig_duration.value
	var presence := trig_presence.get_selected_id()
	var cond := trig_condition.text
	var on_a := trig_on_activate.text
	var on_d := trig_on_deactivate.text

	t.title = t_title
	t.area_shape = shape as ScenarioTrigger.AreaShape
	t.area_size_m = Vector2(size_x, size_y)
	t.require_duration_s = dur
	t.presence = presence as ScenarioTrigger.PresenceMode
	t.condition_expr = cond
	t.on_activate_expr = on_a
	t.on_deactivate_expr = on_d

	emit_signal("saved", trigger_index, t)
	visible = false
	editor._request_overlay_redraw()
