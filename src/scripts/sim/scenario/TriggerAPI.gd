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
var _dialog_blocking: bool = false
var _dialog_pending_expr: String = ""
var _dialog_pending_ctx: Dictionary = {}
var _bridges_built: int = 0  # Counter for completed bridges
var _artillery_called: int = 0  # Counter for artillery missions
var _current_context: Dictionary = {}  # Current trigger execution context


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
## Optionally specify which unit is speaking for the transcript.
## [param msg] Radio message.
## [param level] Optional Log level (info|warn|error).
## [param unit] Optional unit callsign/ID of the speaker (for transcript display).
func radio(msg: String, level: String = "info", unit_say: String = "") -> void:
	if sim:
		sim.emit_signal("radio_message", level, msg, unit_say)


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


## Find callsign of first playable unit with the specified role.
## Searches through playable units and returns the callsign of the first unit
## whose UnitData.role matches the specified role string.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## var recon_cs = find_callsign_by_role("RECON");
## var armor_cs = find_callsign_by_role("ARMOR");
## var at_cs = find_callsign_by_role("AT");
## [/codeblock]
## [param role] Role string to search for (e.g., "RECON", "ARMOR", "AT", "ENG").
## [return] Callsign string of first matching unit, or empty string if not found.
func find_callsign_by_role(role: String) -> String:
	if not engine or not engine._scenario:
		return ""

	var playable_units: Array = engine._scenario.playable_units
	for su in playable_units:
		if su == null or su.unit == null:
			continue
		if su.unit.role == role and not su.callsign.is_empty():
			return su.callsign

	return ""


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


## Get list of friendly unit IDs currently inside the trigger area.
## Only works when called from within a trigger condition or action expression.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Check if tutorial unit entered the trigger
## var tut_unit = get_global("tutorial_unit", "")
## var friends_in_trigger = triggering_units_friend()
## for unit_id in friends_in_trigger:
##     var snap = unit(unit_id)
##     if snap.get("callsign", "") == tut_unit:
##         radio("Tutorial unit entered the area!", "info", tut_unit)
## [/codeblock]
## [return] Array of friendly unit IDs in trigger area, or empty array if not called from trigger.
func triggering_units_friend() -> Array:
	if _current_context.has("units_friend"):
		return _current_context.get("units_friend", [])
	return []


## Get list of enemy unit IDs currently inside the trigger area.
## Only works when called from within a trigger condition or action expression.
## [return] Array of enemy unit IDs in trigger area, or empty array if not called from trigger.
func triggering_units_enemy() -> Array:
	if _current_context.has("units_enemy"):
		return _current_context.get("units_enemy", [])
	return []


## Get list of player-controlled unit IDs currently inside the trigger area.
## Only works when called from within a trigger condition or action expression.
## [return] Array of player unit IDs in trigger area, or empty array if not called from trigger.
func triggering_units_player() -> Array:
	if _current_context.has("units_player"):
		return _current_context.get("units_player", [])
	return []


## Get the first friendly unit ID that triggered this area (convenience method).
## Returns empty string if no friendly units in area.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Check if tutorial unit is the one that triggered
## var tut_unit_cs = get_global("tutorial_unit", "")
## var trigger_unit_id = triggering_unit_friend()
## if trigger_unit_id != "":
##     var snap = unit(trigger_unit_id)
##     if snap.get("callsign", "") == tut_unit_cs:
##         set_unit_fuel(tut_unit_cs, 18.0)
## [/codeblock]
## [return] First friendly unit ID in trigger area, or empty string.
func triggering_unit_friend() -> String:
	var units := triggering_units_friend()
	return units[0] if units.size() > 0 else ""


## Get the first enemy unit ID that triggered this area (convenience method).
## Returns empty string if no enemy units in area.
## [return] First enemy unit ID in trigger area, or empty string.
func triggering_unit_enemy() -> String:
	var units := triggering_units_enemy()
	return units[0] if units.size() > 0 else ""


## Get the first player-controlled unit ID that triggered this area (convenience method).
## Returns empty string if no player units in area.
## [return] First player unit ID in trigger area, or empty string.
func triggering_unit_player() -> String:
	var units := triggering_units_player()
	return units[0] if units.size() > 0 else ""


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
##
## # Block execution until dialog is closed
## show_dialog("First message", true, null, true)
## show_dialog("This shows after first is closed", true, null, true)
## [/codeblock]
## [param text] Dialog text to display (supports BBCode formatting)
## [param pause_game] If true, pauses simulation until dialog is dismissed
## [param position_m] Optional position on map (in meters) to draw a line to
## [param block] If true, blocks trigger execution until dialog is closed
func show_dialog(
	text: String, pause_game: bool = false, position_m: Variant = null, block: bool = false
) -> void:
	if _mission_dialog and _mission_dialog.has_method("show_dialog"):
		_mission_dialog.show_dialog(text, pause_game, sim, position_m, map_controller)
		if block:
			_dialog_blocking = true
			# Connect to dialog_closed signal if not already connected
			if not _mission_dialog.is_connected("dialog_closed", _on_dialog_closed):
				_mission_dialog.dialog_closed.connect(_on_dialog_closed)


## Show a tutorial dialog with a line pointing to a UI element.
## Designed for tutorial sequences to highlight specific tools, buttons, or UI elements.
## Automatically pauses the simulation and points at the specified node.
## By default, blocks execution until the dialog is dismissed (can be disabled).
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Point to a node by unique name (% prefix) - blocks until dismissed
## tutorial_dialog("This is the radio button. Press spacebar to transmit.", "%RadioButton")
##
## # Point to a node by name (searches from root)
## tutorial_dialog("Use this tool to draw on the map.", "DrawingTool")
##
## # Point to a node by path
## tutorial_dialog("These are your unit cards.", "HBoxContainer/UnitPanel")
##
## # Tutorial sequence - automatically waits for each dialog to be dismissed
## tutorial_dialog("Welcome to the mission!")
## tutorial_dialog("This is the map viewer.", "%MapViewer")
## tutorial_dialog("Click and drag to pan the map.", "%MapViewer")
## tutorial_dialog("Press spacebar to use the radio.", "%RadioButton")
##
## # Non-blocking tutorial dialog (old behavior with sleep_ui)
## tutorial_dialog("Watch this!", "%SomeNode", false)
## sleep_ui(3.0)
## tutorial_dialog("Now this!", "%OtherNode", false)
## [/codeblock]
## [br]
## [b]Note:[/b] The dialog will automatically pause the simulation. Node lookup tries:
## [br]1. Unique name lookup (if starts with %)
## [br]2. Direct path from dialog node
## [br]3. Recursive search from root by name
## [param text] Dialog text to display (supports BBCode formatting)
## [param node_identifier] Node name, unique name (%), or path to point at
## [param block] If true (default), blocks execution until dialog is closed
func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void:
	if _mission_dialog and _mission_dialog.has_method("show_dialog"):
		var target = node_identifier as Variant if node_identifier != "" else null
		_mission_dialog.show_dialog(text, true, sim, null, map_controller, target)
		if block:
			_dialog_blocking = true
			# Connect to dialog_closed signal if not already connected
			if not _mission_dialog.is_connected("dialog_closed", _on_dialog_closed):
				_mission_dialog.dialog_closed.connect(_on_dialog_closed)


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


## Check if a unit is currently in combat (has spotted enemies).
## Returns true if the unit has line-of-sight to any enemy units.
## [br][br]
## [b]Usage in trigger condition:[/b]
## [codeblock]
## # Trigger when ALPHA unit is in combat
## is_unit_in_combat("ALPHA")
##
## # Trigger when any player unit is in combat
## var u = unit("ALPHA")
## if u:
##     is_unit_in_combat(u.id)
##
## # Tutorial: explain combat when ambushed
## is_unit_in_combat("ALPHA") and not has_global("combat_tutorial_shown")
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign to check.
## [return] True if unit has spotted enemies (in combat).
func is_unit_in_combat(id_or_callsign: String) -> bool:
	if not sim:
		return false

	# Try to get unit to resolve callsign -> ID
	var unit_data := unit(id_or_callsign)
	var unit_id := ""
	if unit_data.has("id"):
		unit_id = unit_data.get("id", "")
	else:
		# Fallback: assume it's already an ID
		unit_id = id_or_callsign

	if unit_id == "":
		return false

	# Check if unit has any contacts (spotted enemies)
	var contacts: Array = sim.get_contacts_for_unit(unit_id)
	return contacts.size() > 0


## Get the current position of a unit in terrain meters (Vector2).
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Get unit position
## var pos = get_unit_position("ALPHA")
## radio("ALPHA is at position " + str(pos))
##
## # Check if unit reached a location
## var target = vec2(1000, 500)
## var pos = get_unit_position("ALPHA")
## if pos and pos.distance_to(target) < 50:
##     radio("ALPHA reached the objective!")
##
## # Point dialog at unit's current position
## var pos = get_unit_position("BRAVO")
## if pos:
##     show_dialog("Enemy spotted here!", false, pos)
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign.
## [return] Vector2 position in terrain meters, or null if unit not found.
func get_unit_position(id_or_callsign: String) -> Variant:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return null
	return unit_data.get("position_m", null)


## Get the current grid position of a unit (e.g., "630852").
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Get unit grid position
## var grid = get_unit_grid("ALPHA")
## radio("ALPHA is at grid " + grid)
##
## # Tutorial: explain grid coordinates
## var grid = get_unit_grid("ALPHA")
## tutorial_dialog("You are at grid " + grid + ". Use this for radio reports.")
##
## # Check if unit is in specific grid area
## var grid = get_unit_grid("BRAVO")
## if grid.begins_with("63"):
##     radio("BRAVO is in the northern sector")
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign.
## [param digits] Total number of digits in grid (default 6).
## [return] Grid position string (e.g., "630852"), or empty string if unit not found.
func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String:
	var pos: Variant = get_unit_position(id_or_callsign)
	if pos == null or not (pos is Vector2):
		return ""

	if map_controller == null or map_controller.renderer == null:
		return ""

	return map_controller.renderer.pos_to_grid(pos, digits)


## Check if a unit is destroyed (wiped out, state_strength == 0).
## Returns true if the unit is dead or has zero strength.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Trigger when ALPHA is destroyed
## is_unit_destroyed("ALPHA")
##
## # Check for unit destruction and complete objective
## if is_unit_destroyed("ENEMY_1"):
##     complete_objective("destroy_enemy")
##     radio("Enemy unit eliminated!")
##
## # Tutorial: explain unit loss
## if is_unit_destroyed("ALPHA") and not has_global("unit_loss_tutorial_shown"):
##     set_global("unit_loss_tutorial_shown", true)
##     show_dialog("Your unit has been destroyed!", true)
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign to check.
## [return] True if unit is destroyed/dead, false if alive or not found.
func is_unit_destroyed(id_or_callsign: String) -> bool:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return false
	return unit_data.get("dead", false)


## Get the current strength of a unit.
## Strength is calculated as base strength × state_strength.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Check if unit is below 50% strength
## if get_unit_strength("ALPHA") < 50:
##     radio("ALPHA is heavily damaged!")
##
## # Trigger when unit strength is critical
## get_unit_strength("ALPHA") > 0 and get_unit_strength("ALPHA") < 20
##
## # Compare strengths
## var alpha_str = get_unit_strength("ALPHA")
## var bravo_str = get_unit_strength("BRAVO")
## if alpha_str > bravo_str * 2:
##     radio("ALPHA is significantly stronger than BRAVO")
##
## # Tutorial: explain unit strength
## if get_unit_strength("ALPHA") < 30 and not has_global("strength_warning_shown"):
##     set_global("strength_warning_shown", true)
##     tutorial_dialog("Your unit strength is low! Consider withdrawing.")
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign.
## [return] Current strength value (0.0 if destroyed/not found).
func get_unit_strength(id_or_callsign: String) -> float:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return 0.0
	return unit_data.get("strength", 0.0)


## Set the fuel level of a unit (for scripted events and tutorials).
## Fuel is specified as a percentage (0-100).
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Lower unit fuel to 20% for tutorial
## set_unit_fuel("ALPHA", 20.0)
##
## # Deplete fuel during retreat
## var tut_unit = get_global("tutorial_unit", "")
## if tut_unit != "":
##     set_unit_fuel(tut_unit, 15.0)
##     radio(tut_unit + " is running low on fuel!")
##
## # Restore fuel after resupply
## set_unit_fuel("BRAVO", 100.0)
##
## # Tutorial: create fuel emergency
## if not has_global("fuel_tutorial_triggered"):
##     set_global("fuel_tutorial_triggered", true)
##     set_unit_fuel("ALPHA", 18.0)
##     show_dialog("Your fuel is critically low! Resupply immediately.")
## [/codeblock]
## [param id_or_callsign] Unit ID or callsign.
## [param fuel_pct] Fuel percentage (0-100).
## [return] True if fuel was successfully set, false if unit or FuelSystem not found.
func set_unit_fuel(id_or_callsign: String, fuel_pct: float) -> bool:
	if not sim:
		return false

	# Resolve callsign to unit ID
	var unit_data := unit(id_or_callsign)
	var unit_id := ""
	if unit_data.has("id"):
		unit_id = unit_data.get("id", "")
	else:
		# Fallback: assume it's already an ID
		unit_id = id_or_callsign

	if unit_id == "":
		return false

	# Find FuelSystem in scene tree
	var fuel_system = null
	var tree := sim.get_tree()
	if tree:
		var nodes := tree.get_nodes_in_group("FuelSystem")
		if nodes.size() > 0:
			fuel_system = nodes[0]

	if fuel_system == null or not fuel_system.has_method("get_fuel_state"):
		return false

	# Get fuel state for this unit
	var fuel_state = fuel_system.get_fuel_state(unit_id)
	if fuel_state == null:
		return false

	# Clamp fuel percentage to 0-100 range
	var clamped_pct: float = clamp(fuel_pct, 0.0, 100.0)

	# Set fuel level (as percentage of capacity)
	fuel_state.state_fuel = (clamped_pct / 100.0) * fuel_state.fuel_capacity

	return true


## Check if any engineers have built a bridge.
## Returns true if at least one bridge has been completed.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Trigger when first bridge is built
## has_built_bridge()
##
## # Tutorial: explain bridge building
## if has_built_bridge() and not has_global("bridge_tutorial_shown"):
##     set_global("bridge_tutorial_shown", true)
##     radio("Well done! The bridge is complete.")
##     show_dialog("Engineers can build bridges across water obstacles.")
##
## # Complete objective when bridge built
## if has_built_bridge():
##     complete_objective("build_crossing")
## [/codeblock]
## [return] True if at least one bridge has been built.
func has_built_bridge() -> bool:
	return _bridges_built > 0


## Get the number of bridges built by engineers.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Trigger when 2 bridges are built
## get_bridges_built() >= 2
##
## # Radio report on progress
## var count = get_bridges_built()
## radio("Engineers have completed " + str(count) + " bridge(s)")
##
## # Tutorial: reinforce successful bridge building
## if get_bridges_built() >= 3:
##     show_dialog("Excellent work! Your engineers are very efficient.")
## [/codeblock]
## [return] Number of bridges built.
func get_bridges_built() -> int:
	return _bridges_built


## Check if any artillery fire missions have been called.
## Returns true if at least one artillery mission has been requested.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Trigger when first artillery is called
## has_called_artillery()
##
## # Tutorial: explain artillery usage
## if has_called_artillery() and not has_global("artillery_tutorial_shown"):
##     set_global("artillery_tutorial_shown", true)
##     radio("Shot! Rounds on the way.")
##     show_dialog("Artillery takes time to impact. Listen for 'Splash' warning.")
##
## # Complete objective when artillery called
## if has_called_artillery():
##     complete_objective("call_fire_support")
## [/codeblock]
## [return] True if at least one artillery mission has been called.
func has_called_artillery() -> bool:
	return _artillery_called > 0


## Get the number of artillery fire missions called.
## [br][br]
## [b]Usage in trigger expressions:[/b]
## [codeblock]
## # Trigger when 3 fire missions called
## get_artillery_calls() >= 3
##
## # Radio report on fire support usage
## var count = get_artillery_calls()
## radio("We've called " + str(count) + " fire mission(s) so far")
##
## # Tutorial: warn about ammo conservation
## if get_artillery_calls() > 5:
##     show_dialog("Watch your artillery ammunition - you only have limited rounds!")
## [/codeblock]
## [return] Number of artillery missions called.
func get_artillery_calls() -> int:
	return _artillery_called


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


## Check if dialog blocking is active (internal use by TriggerVM).
## [return] True if waiting for dialog to close.
func _is_dialog_blocking() -> bool:
	return _dialog_blocking


## Set pending expression to execute when dialog closes (internal use by TriggerVM).
## [param expr] Expression to execute.
## [param ctx] Context dictionary.
func _set_dialog_pending(expr: String, ctx: Dictionary) -> void:
	_dialog_pending_expr = expr
	_dialog_pending_ctx = ctx


## Handle dialog closed signal (internal).
func _on_dialog_closed() -> void:
	_dialog_blocking = false
	# Disconnect the signal to avoid memory leaks
	if _mission_dialog and _mission_dialog.is_connected("dialog_closed", _on_dialog_closed):
		_mission_dialog.dialog_closed.disconnect(_on_dialog_closed)

	# Execute pending expression if any
	if _dialog_pending_expr != "" and engine:
		var expr := _dialog_pending_expr
		var ctx := _dialog_pending_ctx
		_dialog_pending_expr = ""
		_dialog_pending_ctx = {}
		# Execute the remaining statements
		engine.execute_expression(expr, ctx)


## Bind to EngineerController to track bridge completions (internal, called by TriggerEngine).
## [param engineer_ctrl] EngineerController reference.
func _bind_engineer_controller(engineer_ctrl: EngineerController) -> void:
	if engineer_ctrl and not engineer_ctrl.task_completed.is_connected(_on_engineer_task_completed):
		engineer_ctrl.task_completed.connect(_on_engineer_task_completed)


## Bind to ArtilleryController to track fire missions (internal, called by TriggerEngine).
## [param artillery_ctrl] ArtilleryController reference.
func _bind_artillery_controller(artillery_ctrl: ArtilleryController) -> void:
	if artillery_ctrl and not artillery_ctrl.mission_confirmed.is_connected(_on_artillery_called):
		artillery_ctrl.mission_confirmed.connect(_on_artillery_called)


## Handle engineer task completion signal (internal).
func _on_engineer_task_completed(_unit_id: String, task_type: String, _target_pos: Vector2) -> void:
	if task_type.to_lower() == "bridge" or task_type.to_lower() == "build_bridge":
		_bridges_built += 1


## Handle artillery mission confirmed signal (internal).
func _on_artillery_called(
	_unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int
) -> void:
	_artillery_called += 1
