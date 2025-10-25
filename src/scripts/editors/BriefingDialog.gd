class_name BriefingDialog
extends Window
## Briefing editor dialog (create/edit BriefData, manage objectives).

## Emitted when user presses Save with a completed BriefData.
signal request_update(brief: BriefData)

## Editing mode for the dialog.
enum DialogMode { CREATE, EDIT }

## Attached editor.
@export var editor: ScenarioEditor

var dialog_mode: DialogMode = DialogMode.CREATE
var working: BriefData

@onready var title_input: LineEdit = %Title
@onready var enemy_input: TextEdit = %EnySituation
@onready var friendly_input: TextEdit = %FrSituation
@onready var terrain_input: TextEdit = %Terrain
@onready var mission_input: TextEdit = %Mission
@onready var execution_input: TextEdit = %Execution
@onready var admin_logi_input: TextEdit = %AdminLogi

@onready var objective_dialog: ObjectiveDialog = %ObjectiveDialog
@onready var objectives_vbox: VBoxContainer = %ObjectiveVBox
@onready var objective_add: Button = %ObjectiveAdd
@onready var close_btn: Button = %Close
@onready var save_btn: Button = %Save


## Wire buttons.
func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	objective_add.pressed.connect(_on_add_objective)
	objective_dialog.request_create.connect(_on_objective_create)
	objective_dialog.request_update.connect(_on_objective_update)


## Open/close the dialog. If `existing` is null -> create mode.
## [param state] True shows dialog, false hides it.
## [param existing] Optional briefing data to edit.
func show_dialog(state: bool, existing: BriefData = null) -> void:
	if not state:
		visible = false
		working = null
		_reset_ui()
		return

	if existing:
		dialog_mode = DialogMode.EDIT
		working = existing.duplicate(true) as BriefData
	else:
		dialog_mode = DialogMode.CREATE
		working = BriefData.new()
		working.frag_objectives = []

	_load_from_working()
	visible = true


## Load UI from working copy.
func _load_from_working() -> void:
	title_input.text = String(working.title)
	enemy_input.text = String(working.frag_enemy)
	friendly_input.text = String(working.frag_friendly)
	terrain_input.text = String(working.frag_terrain)
	mission_input.text = String(working.frag_mission)
	execution_input.text = String(working.frag_execution)
	admin_logi_input.text = String(working.frago_logi)

	if working.frag_objectives == null:
		working.frag_objectives = []
	_rebuild_objectives()


## Clear UI to defaults.
func _reset_ui() -> void:
	for node in [
		title_input,
		enemy_input,
		friendly_input,
		terrain_input,
		mission_input,
		execution_input,
		admin_logi_input
	]:
		if node:
			node.text = ""
	for c in objectives_vbox.get_children():
		c.queue_free()


## Collect UI -> working copy.
func _collect_into_working() -> void:
	working.title = title_input.text.strip_edges()
	working.frag_enemy = enemy_input.text.strip_edges()
	working.frag_friendly = friendly_input.text.strip_edges()
	working.frag_terrain = terrain_input.text.strip_edges()
	working.frag_mission = mission_input.text.strip_edges()
	working.frag_execution = execution_input.text.strip_edges()
	working.frago_logi = admin_logi_input.text.strip_edges()
	if working.frag_objectives == null:
		working.frag_objectives = []


## Build objective rows: [Title] [Score] [Edit] [Delete]
func _rebuild_objectives() -> void:
	for c in objectives_vbox.get_children():
		c.queue_free()

	for i in range(working.frag_objectives.size()):
		var o: ScenarioObjectiveData = working.frag_objectives[i]

		var row := HBoxContainer.new()
		row.custom_minimum_size.y = 28

		var t := Label.new()
		t.text = o.title
		t.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var s := Label.new()
		s.text = str(o.score)
		s.custom_minimum_size.x = 72
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		var edit := Button.new()
		edit.text = "Edit"

		var del := Button.new()
		del.text = "Delete"

		var idx := i
		var obj := o
		edit.pressed.connect(func(): objective_dialog.popup_edit(idx, obj))
		del.pressed.connect(
			func():
				var nxt: Array[ScenarioObjectiveData] = []
				for j in range(working.frag_objectives.size()):
					if j != idx:
						nxt.append(working.frag_objectives[j])
				working.frag_objectives = nxt
				_rebuild_objectives()
		)

		row.add_child(t)
		row.add_child(s)
		row.add_child(edit)
		row.add_child(del)
		objectives_vbox.add_child(row)


## Open small dialog to create a new [class ObjectiveData].
func _on_add_objective() -> void:
	objective_dialog.popup_create()


## Save [class ScenarioObjectiveData] to scenario.
func _on_objective_create(obj: ScenarioObjectiveData) -> void:
	working.frag_objectives.append(obj)
	_rebuild_objectives()


## Apply edited objective at index (preserve id if it existed).
func _on_objective_update(index: int, obj: ScenarioObjectiveData) -> void:
	if index < 0 or index >= working.frag_objectives.size():
		return

	working.frag_objectives[index] = obj
	_rebuild_objectives()


## Save current working copy and notify parent.
func _on_save() -> void:
	_collect_into_working()

	if String(working.id).strip_edges() == "":
		working.id = "%s_brief" % editor.ctx.data.title.to_lower().replace(" ", "_")
	emit_signal("request_update", working)
	show_dialog(false)


## Make a lightweight slug from title.
static func _slug(s: String) -> String:
	var out := ""
	for ch in s.to_lower():
		if ch.is_valid_identifier() or ch in ["-", "_"]:
			out += ch
		elif ch == " ":
			out += "_"
	return out
