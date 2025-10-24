class_name TriggerAPI
extends RefCounted
## Whitelisted helper API for trigger scripts.
## Methods are available inside condition/on_activate/on_deactivate expressions.

var sim: SimWorld
var engine: TriggerEngine
var _last_radio_command: String = ""
var _mission_dialog: Control = null


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


## Get the last radio command heard this tick (cleared after tick).
## Useful for trigger conditions to match custom voice commands.
## [br][br]
## [b]Usage in trigger condition_expr:[/b]
## [codeblock]
## last_radio_command().contains("fire mission")
## last_radio_command() == "thunder actual"
## [/codeblock]
## [br]
## [b]Note:[/b] Command is automatically cleared after each tick, so triggers
## only fire once per voice command.
## [return] Last radio command text (lowercase, normalized).
func last_radio_command() -> String:
	return _last_radio_command


## Internal: Set the last radio command (called by TriggerEngine).
## [param cmd] Raw command text from Radio.
func _set_last_radio_command(cmd: String) -> void:
	_last_radio_command = cmd.to_lower().strip_edges()


## Get a global variable shared across all triggers.
## Global variables persist across ticks and are visible to all triggers.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # In trigger A:
## set_global("mission_phase", 2)
##
## # In trigger B (can read what A wrote):
## if get_global("mission_phase", 0) >= 2:
##     radio("Phase 2 started")
## [/codeblock]
## [param key] Variable name.
## [param default] Default value if variable doesn't exist.
## [return] Variable value or default.
func get_global(key: String, default: Variant = null) -> Variant:
	if engine:
		return engine.get_global(key, default)
	return default


## Set a global variable shared across all triggers.
## Global variables persist across ticks and are visible to all triggers.
## [param key] Variable name.
## [param value] Value to store.
func set_global(key: String, value: Variant) -> void:
	if engine:
		engine.set_global(key, value)


## Check if a global variable exists.
## [param key] Variable name.
## [return] True if variable exists.
func has_global(key: String) -> bool:
	if engine:
		return engine.has_global(key)
	return false


## Show a mission dialog with text and an OK button.
## Optionally pauses the simulation until the player dismisses the dialog.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Show dialog without pausing
## show_dialog("Enemy reinforcements spotted!")
##
## # Show dialog and pause game
## show_dialog("Mission briefing: Secure the village.", true)
## [/codeblock]
## [param text] Dialog text to display (supports BBCode formatting)
## [param pause_game] If true, pauses simulation until dialog is dismissed
func show_dialog(text: String, pause_game: bool = false) -> void:
	if _mission_dialog and _mission_dialog.has_method("show_dialog"):
		_mission_dialog.show_dialog(text, pause_game, sim)
