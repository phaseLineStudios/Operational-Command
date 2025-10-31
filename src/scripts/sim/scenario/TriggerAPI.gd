class_name TriggerAPI
extends RefCounted
## Whitelisted helper API for trigger scripts.
## Methods are available inside condition/on_activate/on_deactivate expressions.

var sim: SimWorld
var engine: TriggerEngine
var drawing_controller = null  # DrawingController reference
var map_controller: MapController = null  # MapController reference for position conversion

var _last_radio_command: String = ""
var _mission_dialog: Control = null
var _counter_controller = null  # UnitCounterController reference
var _sleep_requested: bool = false
var _sleep_duration: float = 0.0
var _sleep_use_realtime: bool = false


## Return mission time in seconds.
## [return] Mission time in seconds.
func time_s() -> float:
	return sim.get_mission_time_s() if sim else 0.0


## Check if simulation is paused.
## [return] True if simulation is paused.
func is_paused() -> bool:
	if sim:
		return sim.get_state() == SimWorld.State.PAUSED
	return false


## Check if simulation is running.
## [return] True if simulation is running.
func is_running() -> bool:
	if sim:
		return sim.get_state() == SimWorld.State.RUNNING
	return false


## Get current time scale (1.0 = normal, 2.0 = 2x speed).
## [return] Current time scale multiplier.
func time_scale() -> float:
	return sim.get_time_scale() if sim else 1.0


## Get simulation state as string ("INIT", "RUNNING", "PAUSED", "COMPLETED").
## [return] Current simulation state name.
func sim_state() -> String:
	if not sim:
		return "INIT"
	match sim.get_state():
		SimWorld.State.INIT:
			return "INIT"
		SimWorld.State.RUNNING:
			return "RUNNING"
		SimWorld.State.PAUSED:
			return "PAUSED"
		SimWorld.State.COMPLETED:
			return "COMPLETED"
		_:
			return "UNKNOWN"


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
## Can display a line from the dialog to a position on the map.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Show dialog without pausing
## show_dialog("Enemy reinforcements spotted!")
##
## # Show dialog and pause game
## show_dialog("Mission briefing: Secure the village.", true)
##
## # Show dialog with a line pointing to a map position
## show_dialog("Check this location!", false, vec2(500, 750))
##
## # Show dialog pointing to a unit's position
## var enemy = unit("BRAVO")
## if enemy:
##     show_dialog("Watch out for enemies here!", true, enemy.position_m)
## [/codeblock]
## [param text] Dialog text to display (supports BBCode formatting)
## [param pause_game] If true, pauses simulation until dialog is dismissed
## [param position_m] Optional position on map (in meters) to draw a line to
func show_dialog(text: String, pause_game: bool = false, position_m: Variant = null) -> void:
	if _mission_dialog and _mission_dialog.has_method("show_dialog"):
		_mission_dialog.show_dialog(text, pause_game, sim, position_m, map_controller)


## Check if the player has drawn anything on the map.
## Returns true if any pen strokes have been made with the drawing tools.
## [br][br]
## [b]Usage in trigger condition:[/b]
## [codeblock]
## # Trigger activates when player has drawn on the map
## has_drawn()
##
## # Combined with other conditions
## has_drawn() and time_s() > 60
## [/codeblock]
## [return] True if player has made any drawings.
func has_drawn() -> bool:
	if drawing_controller and drawing_controller.has_method("has_drawing"):
		return drawing_controller.has_drawing()
	return false


## Get the number of drawing strokes the player has made.
## Each continuous pen stroke counts as one stroke.
## [br][br]
## [b]Usage in trigger condition:[/b]
## [codeblock]
## # Trigger when player has drawn at least 3 strokes
## get_drawing_count() >= 3
##
## # Combined with location check
## get_drawing_count() > 0 and count_in_area("friend", Vector2(500, 500), Vector2(100, 100)) > 0
## [/codeblock]
## [return] Number of strokes drawn.
func get_drawing_count() -> int:
	if drawing_controller and drawing_controller.has_method("get_stroke_count"):
		return drawing_controller.get_stroke_count()
	return 0


## Check if the player has created any unit counters.
## Returns true if at least one counter has been spawned.
## [br][br]
## [b]Usage in trigger condition:[/b]
## [codeblock]
## # Trigger activates when player has created a counter
## has_created_counter()
##
## # Combined with other conditions
## has_created_counter() and time_s() > 30
## [/codeblock]
## [return] True if player has created at least one counter.
func has_created_counter() -> bool:
	if _counter_controller and _counter_controller.has_method("get_counter_count"):
		return _counter_controller.get_counter_count() > 0
	return false


## Get the number of unit counters the player has created.
## [br][br]
## [b]Usage in trigger condition:[/b]
## [codeblock]
## # Trigger when player has created at least 3 counters
## get_counter_count() >= 3
##
## # Combined with other conditions
## get_counter_count() > 0 and time_s() > 60
## [/codeblock]
## [return] Number of counters created.
func get_counter_count() -> int:
	if _counter_controller and _counter_controller.has_method("get_counter_count"):
		return _counter_controller.get_counter_count()
	return 0


## Create a Vector2 from x and y coordinates.
## Use this helper to construct Vector2 in trigger expressions.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Show dialog with line to position
## show_dialog("Check here!", false, vec2(500, 750))
##
## # Store position in global variable
## set_global("checkpoint", vec2(1000, 500))
## [/codeblock]
## [param x] X coordinate
## [param y] Y coordinate
## [return] Vector2 with given coordinates
func vec2(x: float, y: float) -> Vector2:
	return Vector2(x, y)


## Create a Vector3 from x, y, and z coordinates.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Create 3D position
## set_global("spawn_point", vec3(500, 0, 750))
## [/codeblock]
## [param x] X coordinate
## [param y] Y coordinate
## [param z] Z coordinate
## [return] Vector3 with given coordinates
func vec3(x: float, y: float, z: float) -> Vector3:
	return Vector3(x, y, z)


## Create a Color from RGB or RGBA values (0.0 to 1.0).
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Create red color
## set_global("marker_color", color(1.0, 0.0, 0.0))
##
## # Create semi-transparent blue
## set_global("marker_color", color(0.0, 0.0, 1.0, 0.5))
## [/codeblock]
## [param r] Red component (0.0 to 1.0)
## [param g] Green component (0.0 to 1.0)
## [param b] Blue component (0.0 to 1.0)
## [param a] Alpha component (0.0 to 1.0), defaults to 1.0
## [return] Color with given components
func color(r: float, g: float, b: float, a: float = 1.0) -> Color:
	return Color(r, g, b, a)


## Create a Rect2 from position and size.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Create rectangle area
## set_global("patrol_area", rect2(500, 750, 200, 100))
## [/codeblock]
## [param x] X position
## [param y] Y position
## [param width] Width
## [param height] Height
## [return] Rect2 with given position and size
func rect2(x: float, y: float, width: float, height: float) -> Rect2:
	return Rect2(x, y, width, height)


## Pause execution for a duration (mission time).
## All statements after this call will be delayed by the specified duration.
## Uses mission time, so pausing the game pauses the sleep timer.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Show sequential messages
## show_dialog("First message")
## sleep(5.0)
## show_dialog("Second message after 5 seconds")
## sleep(3.0)
## show_dialog("Third message after 8 seconds total")
##
## # Countdown sequence
## radio("Starting countdown...")
## sleep(3.0)
## radio("3...")
## sleep(3.0)
## radio("2...")
## sleep(3.0)
## radio("1...")
## sleep(3.0)
## radio("Go!")
## set_objective("start", 1)
##
## # Dialog with position then delayed attack order
## show_dialog("Watch this position", false, vec2(500, 500))
## sleep(5.0)
## show_dialog("Attack here!", false, vec2(1000, 1000))
## sleep(2.0)
## radio("All units, engage!")
## [/codeblock]
## [param duration_s] Duration in seconds (mission time) to pause execution
func sleep(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = false


## Pause execution for a duration (real-time).
## All statements after this call will be delayed by the specified duration.
## Uses real-time, so the sleep continues even when the game is paused.
## Useful for UI sequences and tutorials.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Tutorial sequence that continues even if player pauses
## show_dialog("Welcome to the tutorial", true)
## sleep_ui(2.0)
## show_dialog("Step 1: Use radio checks", true)
## sleep_ui(3.0)
## show_dialog("Step 2: Place markers", true)
##
## # Timed UI feedback
## radio("Command acknowledged")
## sleep_ui(1.5)
## radio("Executing order...")
## sleep_ui(2.0)
## radio("Order complete")
## [/codeblock]
## [param duration_s] Duration in seconds (real-time) to pause execution
func sleep_ui(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = true


## Check if sleep was requested (internal use by TriggerVM).
## [return] True if sleep was called.
func _is_sleep_requested() -> bool:
	return _sleep_requested


## Get sleep duration (internal use by TriggerVM).
## [return] Sleep duration in seconds.
func _get_sleep_duration() -> float:
	return _sleep_duration


## Check if sleep uses realtime (internal use by TriggerVM).
## [return] True if sleep_ui was called, false if sleep was called.
func _is_sleep_realtime() -> bool:
	return _sleep_use_realtime


## Reset sleep state (internal use by TriggerVM).
func _reset_sleep() -> void:
	_sleep_requested = false
	_sleep_duration = 0.0
	_sleep_use_realtime = false
