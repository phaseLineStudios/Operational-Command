class_name CampaignSave
extends Resource
## Campaign save data for persistence.
##
## Tracks progress through a campaign: completed missions, current mission,
## unit states, and metadata. Can be serialized to/from JSON for file storage.

## Unique identifier for this save
@export var save_id: String = ""
## Human-readable name for this save
@export var save_name: String = ""
## Campaign ID this save belongs to
@export var campaign_id: String = ""
## Unix timestamp of save creation
@export var created_timestamp: int = 0
## Unix timestamp of last update
@export var last_played_timestamp: int = 0

@export_category("Campaign Progress")
## List of completed scenario IDs
@export var completed_missions: Array[String] = []
## Current/active scenario ID (empty if at campaign start)
@export var current_mission: String = ""
## Furthest mission reached (for forward-only persistence)
@export var furthest_mission: String = ""
## Total playtime in seconds
@export var total_playtime_seconds: float = 0.0
## Unit states at the START of each mission (for replay support)
## Format: { "mission_id": { "unit_id": { state } } }
@export var mission_start_states: Dictionary = {}

@export_category("Unit State")
## Dictionary mapping unit IDs to their persistent state
## Format: { "unit_id": { "state_strength": float, "state_injured": float, ... } }
@export var unit_states: Dictionary = {}


## Create a new campaign save with initial values.
static func create_new(p_campaign_id: String, p_save_name: String = "") -> Resource:
	var save = CampaignSave.new()
	save.set("campaign_id", p_campaign_id)
	save.set("save_id", "save_" + str(Time.get_unix_time_from_system()))
	save.set(
		"save_name",
		p_save_name if p_save_name != "" else "Save " + Time.get_datetime_string_from_system()
	)
	save.set("created_timestamp", Time.get_unix_time_from_system())
	save.set("last_played_timestamp", save.get("created_timestamp"))
	save.set("completed_missions", [])
	save.set("current_mission", "")
	save.set("furthest_mission", "")
	save.set("total_playtime_seconds", 0.0)
	save.set("unit_states", {})
	save.set("mission_start_states", {})
	return save


## Mark a mission as completed and update furthest progress.
func complete_mission(mission_id: String) -> void:
	if mission_id not in completed_missions:
		completed_missions.append(mission_id)

	# Update furthest mission if this is new progress
	# This assumes missions have numeric suffixes or ordering
	if furthest_mission == "" or _is_mission_further(mission_id, furthest_mission):
		furthest_mission = mission_id


## Check if mission A is further than mission B in campaign order.
## Simple heuristic: compare mission IDs lexicographically.
func _is_mission_further(mission_a: String, mission_b: String) -> bool:
	# Extract numeric suffix if present (e.g., "mission_01" -> 1)
	var num_a := _extract_mission_number(mission_a)
	var num_b := _extract_mission_number(mission_b)

	if num_a >= 0 and num_b >= 0:
		return num_a > num_b

	# Fallback to lexicographic comparison
	return mission_a > mission_b


## Extract mission number from mission ID (e.g., "mission_03" -> 3).
func _extract_mission_number(mission_id: String) -> int:
	var regex := RegEx.new()
	regex.compile("\\d+")
	var result := regex.search(mission_id)
	if result:
		return result.get_string().to_int()
	return -1


## Check if a mission is completed.
func is_mission_completed(mission_id: String) -> bool:
	return mission_id in completed_missions


## Update last played timestamp.
func touch() -> void:
	last_played_timestamp = int(Time.get_unix_time_from_system())


## Update unit state for a unit.
## [param unit_id] The unit ID.
## [param state] Dictionary with state keys: state_strength, state_injured,
##               state_equipment, cohesion, state_ammunition.
func update_unit_state(unit_id: String, state: Dictionary) -> void:
	unit_states[unit_id] = state.duplicate()


## Get unit state for a unit, or empty dict if not found.
func get_unit_state(unit_id: String) -> Dictionary:
	return unit_states.get(unit_id, {})


## Serialize to JSON-compatible dictionary.
func serialize() -> Dictionary:
	return {
		"save_id": save_id,
		"save_name": save_name,
		"campaign_id": campaign_id,
		"created_timestamp": created_timestamp,
		"last_played_timestamp": last_played_timestamp,
		"completed_missions": completed_missions.duplicate(),
		"current_mission": current_mission,
		"furthest_mission": furthest_mission,
		"total_playtime_seconds": total_playtime_seconds,
		"unit_states": unit_states.duplicate(true),
		"mission_start_states": mission_start_states.duplicate(true),
	}


## Deserialize from JSON dictionary.
static func deserialize(data: Variant) -> Resource:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var save: Resource = load("res://scripts/data/CampaignSave.gd").new()
	save.save_id = data.get("save_id", "")
	save.save_name = data.get("save_name", "")
	save.campaign_id = data.get("campaign_id", "")
	save.created_timestamp = int(data.get("created_timestamp", 0))
	save.last_played_timestamp = int(data.get("last_played_timestamp", 0))
	save.current_mission = data.get("current_mission", "")
	save.furthest_mission = data.get("furthest_mission", "")
	save.total_playtime_seconds = float(data.get("total_playtime_seconds", 0.0))

	var missions = data.get("completed_missions", [])
	if typeof(missions) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for m in missions:
			if typeof(m) == TYPE_STRING:
				tmp.append(m)
		save.completed_missions = tmp

	var states = data.get("unit_states", {})
	if typeof(states) == TYPE_DICTIONARY:
		save.unit_states = states.duplicate(true)

	var mission_states = data.get("mission_start_states", {})
	if typeof(mission_states) == TYPE_DICTIONARY:
		save.mission_start_states = mission_states.duplicate(true)

	return save
