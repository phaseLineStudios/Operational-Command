extends Control
## Modal dialog for displaying mission messages and events.
##
## Shows text content with an OK button, optionally pausing the simulation.
## Used by TriggerAPI to display narrative moments, objectives, and updates.

signal dialog_closed

var _sim: SimWorld = null
var _was_paused: bool = false
var _should_unpause: bool = false

@onready var _text_label: RichTextLabel = %DialogText
@onready var _ok_button: Button = %OkButton


func _ready() -> void:
	visible = false
	if _ok_button:
		_ok_button.pressed.connect(_on_ok_pressed)


## Show dialog with message text and optional pause
## [param text] Message text to display (supports BBCode)
## [param pause_game] If true, pauses simulation until dialog is dismissed
## [param sim_world] Reference to SimWorld for pause control
func show_dialog(text: String, pause_game: bool = false, sim_world: SimWorld = null) -> void:
	if _text_label:
		_text_label.text = text

	_sim = sim_world
	_should_unpause = false

	# Handle pause if requested
	if pause_game and _sim:
		_was_paused = (_sim.get_state() == SimWorld.State.PAUSED)
		if not _was_paused:
			_sim.pause()
			_should_unpause = true

	visible = true
	if _ok_button:
		_ok_button.grab_focus()


## Hide dialog and optionally resume game
func hide_dialog() -> void:
	visible = false

	# Resume if we paused it
	if _should_unpause and _sim:
		_sim.resume()
		_should_unpause = false

	dialog_closed.emit()


## Handle OK button press
func _on_ok_pressed() -> void:
	hide_dialog()
