extends Node
## Game flow and globals.
##
## Central coordinator that manages scene transitions, difficulty, and access
## to global services. Orchestrates the campaign loop: menus → briefing →
## tactical map → debrief → unit management.

## Emitted when a campaign is selected.
signal campaign_selected(campaign_id: StringName)

## Emitted when a save is selected.
signal save_selected(save_id: StringName)

## Emitted when a mission is selected.
signal mission_selected(mission_id: StringName)

## Emitted when a mission loadout is selected
signal mission_loadout_selected(loadout: Dictionary)

var current_campaign_id: StringName = &""
var current_save_id: StringName = &""
var current_mission_id: StringName = &""
var current_mission_loadout: Dictionary = {}

## Change to scene at [param path]; logs error if missing.
func goto_scene(path: String) -> void:
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_error("Scene not found: %s" % path)

## Set current campaign and emit [signal campaign_selected].
func select_campaign(campaign_id: StringName) -> void:
	current_campaign_id = campaign_id
	emit_signal("campaign_selected", campaign_id)

## Set current save and emit [signal save_selected].
func select_save(save_id: StringName) -> void:
	current_save_id = save_id
	emit_signal("save_selected", save_id)

## Set current mission and emit [signal mission_selected].
func select_mission(mission_id: StringName) -> void:
	current_mission_id = mission_id
	emit_signal("mission_selected", mission_id)

## Set current mission loadout and emit [signal mission_loadout_selected]
func set_mission_loadout(loadout: Dictionary) -> void:
	current_mission_loadout = loadout
	emit_signal("mission_loadout_selected", loadout)
