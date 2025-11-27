extends Control

signal resume_requested
signal restart_requested

var _restart_dialog: ConfirmationDialog
var _exit_dialog: ConfirmationDialog
var _exit_target: String

@onready var resume_btn: Button = %Resume
@onready var restart_btn: Button = %Restart
@onready var settings_btn: Button = %Settings
@onready var scenarios_btn: Button = %Scenarios
@onready var main_menu_btn: Button = %MainMenu
@onready var menu_container: PanelContainer = %MenuContainer
@onready var settings: Settings = %SettingsDisplay


func _ready():
	resume_btn.pressed.connect(_on_resume_pressed)
	restart_btn.pressed.connect(_on_restart_pressed)
	settings_btn.pressed.connect(_on_setting_show)
	settings.back_requested.connect(_on_setting_hide)
	scenarios_btn.pressed.connect(_on_scenarios_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)

	_build_exit_dialog()
	_build_restart_dialog()


func _build_exit_dialog():
	_exit_dialog = ConfirmationDialog.new()
	_exit_dialog.title = "Are you sure you want to exit?"
	_exit_dialog.dialog_text = "This will delete your scenario progress."
	_exit_dialog.get_ok_button().text = "Yes"
	_exit_dialog.get_cancel_button().text = "No"
	_exit_dialog.get_ok_button().pressed.connect(func(): Game.goto_scene(_exit_target))
	add_child(_exit_dialog)


func _build_restart_dialog():
	_restart_dialog = ConfirmationDialog.new()
	_restart_dialog.title = "Are you sure you want to restart?"
	_restart_dialog.dialog_text = "This will delete your scenario progress."
	_restart_dialog.get_ok_button().text = "Yes"
	_restart_dialog.get_cancel_button().text = "No"
	_restart_dialog.get_ok_button().pressed.connect(_on_restart_requested)
	add_child(_restart_dialog)


## Called on resume button pressed.
func _on_resume_pressed() -> void:
	_release_interactions()
	menu_container.visible = false
	visible = false
	emit_signal("resume_requested")


## Called on restart button pressed.
func _on_restart_pressed() -> void:
	_restart_dialog.popup_centered()


## Called when restart is requested.
func _on_restart_requested():
	Game.resolution.finalize(true)
	get_tree().reload_current_scene()
	emit_signal("restart_requested")


## Called on settings button pressed.
func _on_setting_show() -> void:
	menu_container.visible = false
	settings.set_visibility(true)


## called on settings back requested.
func _on_setting_hide() -> void:
	settings.set_visibility(false)
	menu_container.visible = true


## Called on scenario pressed.
func _on_scenarios_pressed() -> void:
	_exit_target = "res://scenes/mission_select.tscn"
	_exit_dialog.popup_centered()


## Called on main menu pressed.
func _on_main_menu_pressed() -> void:
	_exit_target = "res://scenes/main_menu.tscn"
	_exit_dialog.popup_centered()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("pause_menu") and event.is_pressed():
		visible = !visible
		if not visible:
			menu_container.visible = true
			_release_interactions()
		else:
			menu_container.visible = true


func _release_interactions() -> void:
	for controller in get_tree().get_nodes_in_group("interaction_controllers"):
		if controller and controller.has_method("cancel_hold"):
			controller.cancel_hold()
