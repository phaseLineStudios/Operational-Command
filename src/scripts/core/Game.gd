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
## Emitted when a save is deleted.
signal save_deleted(save_id: StringName)
## Emitted when a mission is selected.
signal scenario_selected(mission_id: StringName)
## Emitted when a mission loadout is selected
signal scenario_loadout_selected(loadout: Dictionary)

@export var debug_display_scene: PackedScene = preload("res://scenes/system/debug_display.tscn")
var debug_display: CanvasLayer

var current_campaign: CampaignData
var current_save_id: StringName = &""
var current_save: CampaignSave = null
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
	current_save = Persistence.load_save(save_id)

	if current_save:
		LogService.info("Loaded save: %s" % current_save.save_name, "Game")
	else:
		push_warning("Failed to load save: %s" % save_id)

	emit_signal("save_selected", save_id)


func delete_save(save_id: StringName) -> void:
	var success := Persistence.delete_save(save_id)

	if success:
		LogService.info("Deleted save: %s" % save_id, "Game")
	else:
		push_warning("Failed to delete save: %s" % save_id)

	emit_signal("save_deleted", save_id)


## Set current mission and emit [signal mission_selected].
func select_scenario(scenario: ScenarioData) -> void:
	current_scenario = scenario

	# Restore unit states from save if available
	if current_save:
		restore_unit_states_from_save(scenario)

	LogService.trace("Set Scenario: %s" % current_scenario.id)
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


## Set objective state wrapper
func set_objective_state(id: StringName, state: MissionResolution.ObjectiveState) -> void:
	resolution.set_objective_state(id, state)


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

	# Award experience to surviving units
	_award_experience_to_units()

	# Persist (added later)
	if has_method("save_campaign_state"):
		save_campaign_state()

	goto_scene("res://scenes/debrief.tscn")


## Handle continue from debrief scene
func on_debrief_continue(_payload: Dictionary) -> void:
	# Save campaign state with experience updates
	if current_save:
		save_campaign_state()
		Persistence.save_to_file(current_save)

	# Navigate to campaign/mission select or next mission
	# For now, go back to mission select
	goto_scene("res://scenes/mission_select.tscn")


## Handle retry from debrief scene
func on_debrief_retry(_payload: Dictionary) -> void:
	# Reload the HQ table scene to restart the mission
	goto_scene("res://scenes/hq_table.tscn")


## Handle medal assignment in debrief
## Awards bonus experience to the recipient unit
func on_medal_assigned(medal: String, recipient_name: String) -> void:
	if not current_scenario or not current_scenario.playable_units:
		return

	# Find the unit by name
	var found_unit: ScenarioUnit = null
	for su in current_scenario.playable_units:
		if su and su.unit and su.unit.title == recipient_name:
			found_unit = su
			break

	if not found_unit:
		LogService.warn("Medal recipient not found: %s" % recipient_name, "Game")
		return

	# Award bonus XP for medal (25 XP)
	var medal_bonus := 25.0
	found_unit.unit.experience += medal_bonus

	# Update saved state
	if current_save:
		var saved_state := current_save.get_unit_state(found_unit.unit.id)
		if saved_state.is_empty():
			saved_state = {
				"state_strength": found_unit.state_strength,
				"state_injured": found_unit.state_injured,
				"state_equipment": found_unit.state_equipment,
				"cohesion": found_unit.cohesion,
				"state_ammunition": found_unit.state_ammunition.duplicate(),
				"experience": found_unit.unit.experience,
			}
		else:
			saved_state["experience"] = found_unit.unit.experience

		current_save.update_unit_state(found_unit.unit.id, saved_state)

	LogService.info(
		(
			"Awarded medal '%s' to %s (+%.1f XP, now %.1f total)"
			% [medal, recipient_name, medal_bonus, found_unit.unit.experience]
		),
		"Game"
	)


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


## Award experience to playable units after mission completion.
## Base XP for survival, bonus for success.
func _award_experience_to_units() -> void:
	if not current_scenario or not current_scenario.playable_units:
		return

	if not current_save:
		LogService.debug("No save to persist experience to", "Game")
		return

	# Determine if mission was successful
	var outcome: int = current_scenario_summary.get("outcome", 3)  # FAILED = 3
	var success: bool = outcome == 1  # SUCCESS = 1

	# Base XP: 10 for survival
	# Bonus XP: +15 for mission success
	var base_xp := 10.0
	var success_bonus := 15.0 if success else 0.0
	var total_xp := base_xp + success_bonus

	for su in current_scenario.playable_units:
		if not (su is ScenarioUnit) or not su.unit:
			continue

		# Only award XP if unit survived (strength > 0)
		if su.state_strength <= 0.0:
			continue

		# Award experience
		su.unit.experience += total_xp

		# Update saved state with new experience
		if current_save:
			var saved_state := current_save.get_unit_state(su.unit.id)
			if saved_state.is_empty():
				# Create new state entry
				saved_state = {
					"state_strength": su.state_strength,
					"state_injured": su.state_injured,
					"state_equipment": su.state_equipment,
					"cohesion": su.cohesion,
					"state_ammunition": su.state_ammunition.duplicate(),
					"experience": su.unit.experience,
				}
			else:
				# Update existing entry
				saved_state["experience"] = su.unit.experience

			current_save.update_unit_state(su.unit.id, saved_state)

		LogService.info(
			"Awarded %.1f XP to %s (now %.1f total)" % [total_xp, su.unit.id, su.unit.experience],
			"Game"
		)

	LogService.info(
		"Awarded experience: base=%.1f, success_bonus=%.1f" % [base_xp, success_bonus], "Game"
	)


## Restore unit states from the current campaign save.
## Called when a scenario is selected to apply persistent state across missions.
func restore_unit_states_from_save(scenario: ScenarioData) -> void:
	if not current_save:
		LogService.debug("No save to restore from", "Game")
		return

	if not scenario or not scenario.units:
		LogService.debug("No scenario units to restore", "Game")
		return

	var restored_count := 0

	for su in scenario.units:
		if not (su is ScenarioUnit) or not su.unit:
			continue

		var unit_id := su.unit.id
		var saved_state := current_save.get_unit_state(unit_id)

		if saved_state.is_empty():
			LogService.debug("No saved state for unit: %s, using defaults" % unit_id, "Game")
			# Initialize with template values
			su.state_strength = su.unit.strength
			su.state_injured = 0.0
			su.state_equipment = 1.0
			su.cohesion = 1.0
			su.state_ammunition = su.unit.ammunition.duplicate()
			continue

		# Restore saved state
		su.state_strength = saved_state.get("state_strength", su.unit.strength)
		su.state_injured = saved_state.get("state_injured", 0.0)
		su.state_equipment = saved_state.get("state_equipment", 1.0)
		su.cohesion = saved_state.get("cohesion", 1.0)

		# Restore experience
		su.unit.experience = saved_state.get("experience", su.unit.experience)

		# Restore ammunition state
		var saved_ammo = saved_state.get("state_ammunition", {})
		if saved_ammo is Dictionary and not saved_ammo.is_empty():
			su.state_ammunition = saved_ammo.duplicate()
		else:
			su.state_ammunition = su.unit.ammunition.duplicate()

		restored_count += 1
		LogService.debug(
			(
				"Restored state for %s: strength=%.1f, injured=%.1f, cohesion=%.2f"
				% [unit_id, su.state_strength, su.state_injured, su.cohesion]
			),
			"Game"
		)

	LogService.info("Restored %d unit states from save" % restored_count, "Game")


func save_campaign_state() -> void:
	if not current_save:
		push_warning("Cannot save campaign state: no active save")
		return

	# Update current mission
	if current_scenario:
		current_save.current_mission = current_scenario.id

		# Mark mission as completed if successful
		if current_scenario_summary.has("outcome"):
			var outcome = current_scenario_summary.get("outcome")
			if outcome == MissionResolution.MissionOutcome.SUCCESS:
				current_save.complete_mission(current_scenario.id)
				LogService.info("Marked mission %s as completed" % current_scenario.id, "Game")

	# Update unit states from scenario playable units
	if current_scenario and current_scenario.playable_units:
		for su in current_scenario.playable_units:
			if su is ScenarioUnit and su.unit:
				var state := {
					"state_strength": su.state_strength,
					"state_injured": su.state_injured,
					"state_equipment": su.state_equipment,
					"cohesion": su.cohesion,
					"state_ammunition": su.state_ammunition.duplicate(),
				}
				current_save.update_unit_state(su.unit.id, state)

	# Save to disk
	Persistence.save_to_file(current_save)
