extends Control
## The main menu UI controller.
##
## Controls and manages the main menu scene flow.

@onready var btn_campaign: Button       = $"MenuContainer/CampaignButton"
@onready var btn_scenarios: Button      = $"MenuContainer/ScenariosButton"
@onready var btn_multiplayer: Button    = $"MenuContainer/MultiplayerButton"
@onready var btn_editor: Button         = $"MenuContainer/ScenarioEditorButton"
@onready var btn_settings: Button       = $"MenuContainer/SettingsButton"
@onready var btn_quit: Button           = $"MenuContainer/CloseButton"

const SCENES := {
	"campaign": "res://scenes/campaign_select.tscn",
	"scenarios": "res://scenes/scenario_select.tscn",
	"multiplayer": "res://scenes/multiplayer.tscn",
	"editor": "res://scenes/scenario_editor.tscn",
	"settings": "res://scenes/settings.tscn"
}

func _ready() -> void:
	btn_campaign.pressed.connect(func(): _go("campaign"))
	btn_scenarios.pressed.connect(func(): _go("scenarios"))
	btn_multiplayer.pressed.connect(func(): _go("multiplayer"))
	btn_editor.pressed.connect(func(): _go("editor"))
	btn_settings.pressed.connect(func(): _go("settings"))
	btn_quit.pressed.connect(_quit)

func _go(key: String) -> void:
	var path: String = SCENES.get(key, "")
	if path == "" or not ResourceLoader.exists(path):
		_show_missing_scene_dialog(key, path)
		return
	Game.goto_scene(path)

func _quit() -> void:
	get_tree().quit()

## @experimental Used in development for missing scenes
func _show_missing_scene_dialog(key: String, path: String) -> void:
	var dlg := AcceptDialog.new()
	dlg.title = "Unavailable"
	dlg.dialog_text = "The scene for '%s' isn't available yet.\nPath: %s" % [key, path]
	add_child(dlg)
	dlg.popup_centered()
