extends Control
## The main menu UI controller.
##
## Controls and manages the main menu scene flow.

## Internal state for submenu visibility.
enum SubmenuState { COLLAPSED, EXPANDED }

## Scene registry.
const SCENES := {
	"campaign": "res://scenes/campaign_select.tscn",
	"scenarios": "res://scenes/scenario_select.tscn",
	"multiplayer": "res://scenes/multiplayer.tscn",
	"campaign_editor": "res://scenes/campaign_editor.tscn",
	"scenario_editor": "res://scenes/scenario_editor.tscn",
	"terrain_editor": "res://scenes/terrain_editor.tscn",
	"settings": "res://scenes/settings.tscn"
}

## Labels for submenu buttons
const SUB_BUTTON_TEXT := {
	"campaign_editor": "Campaign Editor",
	"scenario_editor": "Scenario Editor",
	"terrain_editor": "Terrain Editor",
}

var _state: SubmenuState = SubmenuState.COLLAPSED
var _editor_wrapper: VBoxContainer
var _submenu_holder: VBoxContainer

@onready var menu_hbox: VBoxContainer = %MenuContainer
@onready var btn_campaign: OCMenuButton = %CampaignButton
@onready var btn_scenarios: OCMenuButton = %ScenariosButton
@onready var btn_multiplayer: OCMenuButton = %MultiplayerButton
@onready var btn_editor: OCMenuButton = %EditorButton
@onready var btn_settings: OCMenuButton = %SettingsButton
@onready var btn_quit: OCMenuButton = %CloseButton


func _ready() -> void:
	btn_campaign.pressed.connect(
		func():
			_collapse_if_needed()
			_go("campaign")
	)
	btn_scenarios.pressed.connect(
		func():
			_collapse_if_needed()
			_go("scenarios")
	)
	btn_multiplayer.pressed.connect(
		func():
			_collapse_if_needed()
			_go("multiplayer")
	)
	btn_settings.pressed.connect(
		func():
			_collapse_if_needed()
			_go("settings")
	)
	btn_quit.pressed.connect(
		func():
			_collapse_if_needed()
			_quit()
	)

	_wrap_editor_button()

	btn_editor.pressed.connect(_on_editor_pressed)

	_collapse_submenu()


## Change scene by key in SCENES.
func _go(key: String) -> void:
	var path: String = SCENES.get(key, "")
	if path == "" or not ResourceLoader.exists(path):
		_show_missing_scene_dialog(key, path)
		return
	Game.goto_scene(path)


func _quit() -> void:
	get_tree().quit()


## Used in development for missing scenes.
func _show_missing_scene_dialog(key: String, path: String) -> void:
	var dlg := AcceptDialog.new()
	dlg.title = "Unavailable"
	dlg.dialog_text = "The scene for '%s' isn't available yet.\nPath: %s" % [key, path]
	add_child(dlg)
	dlg.popup_centered()


## Reparents the Editor button into a VBox to host submenu buttons below it.
func _wrap_editor_button() -> void:
	if not (menu_hbox and btn_editor):
		return

	var idx := menu_hbox.get_children().find(btn_editor)
	if idx == -1:
		return

	_editor_wrapper = VBoxContainer.new()
	_editor_wrapper.name = "EditorWrapper"
	_editor_wrapper.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	menu_hbox.remove_child(btn_editor)
	menu_hbox.add_child(_editor_wrapper)
	menu_hbox.move_child(_editor_wrapper, idx)

	_editor_wrapper.add_child(btn_editor)

	_submenu_holder = VBoxContainer.new()
	_submenu_holder.name = "EditorSubmenu"
	_submenu_holder.visible = false
	_submenu_holder.add_theme_constant_override("separation", 6)
	_editor_wrapper.add_child(_submenu_holder)

	_build_submenu_buttons()


## Creates 3 submenu buttons and wires them to scene changes.
func _build_submenu_buttons() -> void:
	_clear_children(_submenu_holder)

	# Campaign Editor
	var b_campaign := Button.new()
	b_campaign.text = SUB_BUTTON_TEXT["campaign_editor"]
	b_campaign.focus_mode = Control.FOCUS_ALL
	b_campaign.pressed.connect(
		func():
			_collapse_submenu()
			_go("campaign_editor")
	)
	_submenu_holder.add_child(b_campaign)

	# Scenario Editor
	var b_scenario := Button.new()
	b_scenario.text = SUB_BUTTON_TEXT["scenario_editor"]
	b_scenario.focus_mode = Control.FOCUS_ALL
	b_scenario.pressed.connect(
		func():
			_collapse_submenu()
			_go("scenario_editor")
	)
	_submenu_holder.add_child(b_scenario)

	# Terrain Editor
	var b_terrain := Button.new()
	b_terrain.text = SUB_BUTTON_TEXT["terrain_editor"]
	b_terrain.focus_mode = Control.FOCUS_ALL
	b_terrain.pressed.connect(
		func():
			_collapse_submenu()
			_go("terrain_editor")
	)
	_submenu_holder.add_child(b_terrain)


## Toggle handler for the Editor button.
func _on_editor_pressed() -> void:
	if _state == SubmenuState.COLLAPSED:
		_expand_submenu()
	else:
		_collapse_submenu()


## Expand the submenu below the Editor button.
func _expand_submenu() -> void:
	_submenu_holder.visible = true
	_state = SubmenuState.EXPANDED


## Collapse the submenu.
func _collapse_submenu() -> void:
	_submenu_holder.visible = false
	_state = SubmenuState.COLLAPSED


## Collapse submenu only if expanded
func _collapse_if_needed() -> void:
	if _state == SubmenuState.EXPANDED:
		_collapse_submenu()


static func _queue_free_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()


static func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
