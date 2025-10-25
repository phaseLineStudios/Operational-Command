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
signal scenario_selected(mission_id: StringName)
## Emitted when a mission loadout is selected
signal scenario_loadout_selected(loadout: Dictionary)

@export var debug_display_scene: PackedScene = preload("res://scenes/system/debug_display.tscn")
## Personnel replacements available for pre-mission reinforcement
@export var campaign_replacement_pool: int = 0
var debug_display: CanvasLayer

var current_campaign: CampaignData
var current_save_id: StringName = &""
var current_scenario: ScenarioData
var current_scenario_loadout: Dictionary = {}
var current_scenario_summary: Dictionary = {}

@onready var resolution: MissionResolution = MissionResolution.new()


func ready() -> void:
	add_child(resolution)


func _ready() -> void:
	debug_display = debug_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(debug_display)


## Change to scene at [param path]; logs error if missing.
func goto_scene(path: String) -> void:
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_error("Scene not found: %s" % path)


## Set current campaign and emit [signal campaign_selected].
func select_campaign(campaign: CampaignData) -> void:
	current_campaign = campaign
	emit_signal("campaign_selected", campaign.id)


## Set current save and emit [signal save_selected].
func select_save(save_id: StringName) -> void:
	current_save_id = save_id
	emit_signal("save_selected", save_id)


## Set current mission and emit [signal mission_selected].
func select_scenario(scenario: ScenarioData) -> void:
	current_scenario = scenario
	emit_signal("scenario_selected", scenario.id)


## Set current mission loadout and emit [signal mission_loadout_selected]
func set_scenario_loadout(loadout: Dictionary) -> void:
	current_scenario_loadout = loadout
	emit_signal("scenario_loadout_selected", loadout)


## Start mission
func start_scenario(prim: Array[String]) -> void:
	if current_scenario == null:
		push_error("No scenario loaded. Cannot start scenario")
		return
	resolution.start(prim, current_scenario.id)

	# Try to find the SimWorld in the current scene tree and spawn
	var sim := get_tree().get_root().find_child("SimWorld", true, false)
	if sim and sim.has_method("spawn_scenario_units"):
		sim.spawn_scenario_units(current_scenario)


## Call from mission tick.
func update_loop(dt: float) -> void:
	if is_instance_valid(resolution):
		resolution.tick(dt)


## Complete objective
func complete_objective(id: StringName) -> void:
	resolution.set_objective_state(id, MissionResolution.ObjectiveState.SUCCESS)


## Fail objective
func fail_objective(id: StringName) -> void:
	resolution.set_objective_state(id, MissionResolution.ObjectiveState.FAILED)


## Record casualties
func record_casualties(fr: int, en: int) -> void:
	resolution.add_casualties(fr, en)


## record lost units
func record_unit_lost(count: int = 1) -> void:
	resolution.add_units_lost(count)


## End mission and navigate to debrief
func end_scenario_and_go_to_debrief() -> void:
	current_scenario_summary = resolution.finalize(false)

	# If you have a per-unit losses map, apply it now
	var losses: Dictionary = {}
	# Preferred: pull from your sim/resolution if you track it
	# e.g. losses = resolution.get_losses_by_unit_id()  # { "ALPHA": 3, ... }
	# Or if finalize() summary contains it, use that:
	if current_scenario_summary.has("losses_by_unit"):
		losses = current_scenario_summary["losses_by_unit"]

	if not losses.is_empty():
		# Apply to campaign units so UnitMgmt reflects new strengths
		resolution.apply_casualties_to_units(Game.current_scenario.units, losses)

	# Persist (added later)
	if has_method("save_campaign_state"):
		save_campaign_state()

	goto_scene("res://scenes/debrief.tscn")


## Return available replacements pool
func get_replacement_pool() -> int:
	return int(campaign_replacement_pool)


## Set replacement pool (non-persistent placeholder)
func set_replacement_pool(v: int) -> void:
	campaign_replacement_pool = max(0, int(v))


## Return current units in context for screens that need them.
## Prefer Scenario.units entries, but fall back to unit_recruits.
func get_current_units() -> Array:
	var out: Array = []
	if current_scenario:
		for su in current_scenario.units:
			if su and su.unit:
				out.append(su)
		if out.is_empty():
			for u in current_scenario.unit_recruits:
				if u:
					out.append(u)
	return out


func save_campaign_state() -> void:
	# TODO: implement persistence
	pass
