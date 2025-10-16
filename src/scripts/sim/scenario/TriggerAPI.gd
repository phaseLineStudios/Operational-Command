class_name TriggerAPI
extends RefCounted
## Whitelisted helper API for trigger scripts.
## Methods are available inside condition/on_activate/on_deactivate expressions.

var sim: SimWorld
var engine: TriggerEngine


## Return mission time in seconds.
## [return] Mission time in seconds.
func time_s() -> float:
	return sim.get_mission_time_s() if sim else 0.0


## Send a radio/log message (levels: info|warn|error).
## [param msg] Radio message.
## [param level] Optional Log level.
func radio(msg: String, level: String = "info") -> void:
	if sim:
		sim.emit_signal("radio_message", level, msg)


## Set objective state to completed.
## [param id] Objective ID.
func complete_objective(id: StringName) -> void:
		Game.complete_objective(id)


## Set objective state to failed.
## [param id] Objective ID.
func fail_objective(id: StringName) -> void:
	Game.complete_objective(id)


## Set objective state
## [param id] Objective ID.
## [param state] ObjectiveState enum.
func set_objective(id: StringName, state: int) -> void:
	Game.set_objective_state(id, state)


## Get current objective state via summary payload.
## [param id] Objective ID.
## [return] Current objective state as int.
func objective_state(id: StringName) -> int:
	var d := Game.resolution.to_summary_payload()
	var o: Dictionary = d.get("objectives", {})
	return int(o.get(id, MissionResolution.ObjectiveState.PENDING))


## Minimal snapshot of a unit by id or callsign.
## [param id_or_callsign] Unit ID or Unit Callsign.
## [return] {id, callsign, pos_m: Vector2, aff: int} or {}.
func unit(id_or_callsign: String) -> Dictionary:
	if engine:
		return engine.get_unit_snapshot(id_or_callsign)
	return {}


## Count units in an area by affiliation: "friend"|"enemy"|"player"|"any".
## [param affiliation] Unit affiliation.
## [param center_m] Center of area.
## [param size_m] Size of area.
## [param shape] Shape of area (default "rect").
## [return] Amount of filtered units in area as int.
func count_in_area(
	affiliation: String, center_m: Vector2, size_m: Vector2, shape: String = "rect"
) -> int:
	if engine:
		return engine.count_in_area(affiliation, center_m, size_m, shape)
	return 0


## Return an Array of unit snapshots in an area.
## [param affiliation] Unit affiliation.
## [param center_m] Center of area.
## [param size_m] Size of area.
## [param shape] Shape of area (default "rect").
## [return] Array of filtered units in area
func units_in_area(
	affiliation: String, center_m: Vector2, size_m: Vector2, shape: String = "rect"
) -> Array:
	if engine:
		return engine.units_in_area(affiliation, center_m, size_m, shape)
	return []
