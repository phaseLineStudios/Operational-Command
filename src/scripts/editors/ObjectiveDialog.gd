class_name ObjectiveDialog
extends Window
## Minimal objective dialog (create + edit ScenarioObjectiveData).

## Request objective create.
signal request_create(obj: ScenarioObjectiveData)
## Request objective update (index comes from caller).
signal request_update(index: int, obj: ScenarioObjectiveData)
## Objective creation/edit cancelled.
signal canceled

## Mode the dialog is operating in.
enum DialogMode { CREATE, EDIT }

var _mode: DialogMode = DialogMode.CREATE
var _edit_index: int = -1

@onready var _id: LineEdit = %Id
@onready var _title: LineEdit = %Title
@onready var _success: TextEdit = %Success
@onready var _score: SpinBox = %Score
@onready var _save: Button = %Save
@onready var _cancel: Button = %Cancel

## Wire UI elements.
func _ready() -> void:
	_save.pressed.connect(_on_save)
	_cancel.pressed.connect(_on_cancel)
	close_requested.connect(_on_cancel)

## Open for creating a new objective (clears fields).
func popup_create() -> void:
	_mode = DialogMode.CREATE
	_edit_index = -1
	_id.text = ""
	_title.text = ""
	_success.text = ""
	_score.value = 100
	popup_centered_ratio(0.55)

## Open for editing an objective (prefills fields).
## [param index] Row index in caller’s objectives list.
## [param obj] Objective to edit.
func popup_edit(index: int, obj: ScenarioObjectiveData) -> void:
	_mode = DialogMode.EDIT
	_edit_index = index
	_id.text = obj.id
	_title.text = obj.title
	_success.text = obj.success
	_score.value = obj.score
	popup_centered_ratio(0.55)

## Called when user presses Save.
func _on_save() -> void:
	var o := ScenarioObjectiveData.new()
	o.id = _id.text.strip_edges()
	o.title = _title.text.strip_edges()
	o.success = _success.text.strip_edges()
	o.score = int(_score.value)

	if _mode == DialogMode.CREATE:
		emit_signal("request_create", o)
	else:
		emit_signal("request_update", _edit_index, o)

	hide()

## Called when dialog gets cancelled.
func _on_cancel() -> void:
	hide()
	emit_signal("canceled")
