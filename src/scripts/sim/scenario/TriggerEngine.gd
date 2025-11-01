class_name TriggerEngine
extends Node
## Deterministic evaluator for ScenarioTrigger resources.
## Combines presence checks with a sandboxed condition VM and executes actions.

## SimWorld for time and snapshots
@export var _sim: SimWorld
## If false, call tick(dt) manually from SimWorld
@export var run_in_process := false

var _scenario: ScenarioData
var _vm := TriggerVM.new()
var _api := TriggerAPI.new()
var _snap_by_id: Dictionary = {}
var _id_by_callsign: Dictionary = {}
var _player_ids := {}
var _radio: Radio = null
var _last_radio_text: String = ""
## Shared global variables accessible across all triggers
var _globals: Dictionary = {}
## Scheduled actions queue: [{execute_at: float, expr: String, ctx: Dictionary, use_realtime: bool}]
var _scheduled_actions: Array = []
## Real-time accumulator for sleep_ui
var _realtime_accumulator: float = 0.0


## Wire API.
func _ready() -> void:
	_api.sim = _sim
	_api.engine = self
	_vm.set_api(_api)
	# Bind controllers for tracking
	if _sim:
		if _sim.engineer_controller:
			_api._bind_engineer_controller(_sim.engineer_controller)
		if _sim.artillery_controller:
			_api._bind_artillery_controller(_sim.artillery_controller)
	# Always process to track real-time for sleep_ui
	set_process(true)


## Tick triggers independently and track real-time.
func _process(dt: float) -> void:
	# Track real-time for sleep_ui
	_realtime_accumulator += dt
	# Process real-time scheduled actions (sleep_ui)
	_process_realtime_actions()
	if run_in_process:
		tick(dt)


## Bind scenario to engine.
## [param scenario] Current scenario.
func bind_scenario(scenario: ScenarioData) -> void:
	_scenario = scenario


## Bind radio to listen for raw commands.
## Connects to [signal Radio.radio_raw_command] to capture voice input before parsing.
## Makes raw text available to triggers via [method TriggerAPI.last_radio_command].
## [br][br]
## [b]Called automatically by SimWorld.bind_radio().[/b]
## [param radio] Radio node emitting [signal Radio.radio_raw_command] signal.
func bind_radio(radio: Radio) -> void:
	if _radio and _radio.radio_raw_command.is_connected(_on_radio_raw):
		_radio.radio_raw_command.disconnect(_on_radio_raw)
	_radio = radio
	if _radio and not _radio.radio_raw_command.is_connected(_on_radio_raw):
		_radio.radio_raw_command.connect(_on_radio_raw)


## Bind mission dialog UI for trigger scripts.
## Makes dialog available via [method TriggerAPI.show_dialog].
## [param dialog] MissionDialog node for displaying trigger messages.
func bind_dialog(dialog: Control) -> void:
	_api._mission_dialog = dialog


## Deterministic evaluation entry point.
## [param dt] delta time from last tick.
func tick(dt: float) -> void:
	_refresh_unit_indices()
	_process_mission_time_actions()
	for t in _scenario.triggers:
		_evaluate_trigger(t, dt)
	# Clear radio command after all triggers evaluated
	_last_radio_text = ""
	_api._set_last_radio_command("")


## Refresh unit indices.
func _refresh_unit_indices() -> void:
	_snap_by_id.clear()
	_id_by_callsign.clear()
	_player_ids.clear()

	if _sim:
		for s in _sim.get_unit_snapshots():
			var id := str(s.get("id", ""))
			_snap_by_id[id] = s
			_id_by_callsign[str(s.get("callsign", ""))] = id

	var pm := _scenario.playable_units
	for su in pm:
		if su:
			_player_ids[str(su.id)] = true


## Evaluate a ScenarioTrigger.
## [param t] Trigger to evaluate.
## [param dt] Delta time since last tick.
func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void:
	# Skip evaluation if this is a run_once trigger that has already run
	if t.run_once and t._has_run:
		return

	var presence_ok := _check_presence(t)
	var ctx := _make_ctx(t, presence_ok)
	var condition_ok := _vm.eval_condition(t.condition_expr, ctx)
	var combined := presence_ok and condition_ok

	if combined:
		t._accum_true += dt
	else:
		t._accum_true = 0.0

	var passed: bool = combined and (t._accum_true >= max(0.0, t.require_duration_s))

	if not t._active and passed:
		t._active = true
		_vm.run(t.on_activate_expr, ctx)
		# Mark as run if this is a run_once trigger
		if t.run_once:
			t._has_run = true
	elif t._active and not combined:
		t._active = false
		_vm.run(t.on_deactivate_expr, ctx)


## Check trigger unit presence.
## [param t] Trigger to check unit presence on.
## [return] True if presence passes.
func _check_presence(t: ScenarioTrigger) -> bool:
	if t.presence == ScenarioTrigger.PresenceMode.NONE:
		return true
	var inside := _counts_in_area(t.area_center_m, t.area_size_m, t.area_shape)
	match t.presence:
		ScenarioTrigger.PresenceMode.PLAYER_INSIDE:
			return inside.player > 0
		ScenarioTrigger.PresenceMode.FRIEND_INSIDE:
			return inside.friend > 0
		ScenarioTrigger.PresenceMode.ENEMY_INSIDE:
			return inside.enemy > 0
		ScenarioTrigger.PresenceMode.PLAYER_NOT_INSIDE:
			return inside.player == 0
		ScenarioTrigger.PresenceMode.FRIEND_NOT_INSIDE:
			return inside.friend == 0
		ScenarioTrigger.PresenceMode.ENEMY_NOT_INSIDE:
			return inside.enemy == 0
		_:
			return true


## Build a context to pass to trigger eval.
## [param t] Trigger to create context for.
## [param presence_ok] Check if presence check is ok.
## [return] trigger context.
func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary:
	var counts := _counts_in_area(t.area_center_m, t.area_size_m, t.area_shape)
	var ctx := {
		"trigger_id": t.id,
		"title": t.title,
		"center": t.area_center_m,
		"size": t.area_size_m,
		"presence_ok": presence_ok,
		"count_friend": counts.friend,
		"count_enemy": counts.enemy,
		"count_player": counts.player,
	}
	# Include all global variables in context for easy access
	for key in _globals.keys():
		if not ctx.has(key):  # Don't override built-in context vars
			ctx[key] = _globals[key]
	return ctx


## Count of units in area.
## [param center_m] Center of area
## [param size_m] Size of area.
## [param shape] Shape of area (rect or circle).
## [return] a dictionary of unit counts.
func _counts_in_area(
	center_m: Vector2, size_m: Vector2, shape: ScenarioTrigger.AreaShape
) -> Dictionary:
	var friend := 0
	var enemy := 0
	var player := 0
	for id in _snap_by_id.keys():
		var s: Dictionary = _snap_by_id[id]
		var pos: Vector2 = s.get("pos_m", Vector2.ZERO)
		if _point_in_shape(pos, center_m, size_m, shape):
			var aff := int(s.get("aff", 0))
			if aff == 0:
				friend += 1
			else:
				enemy += 1
			if _player_ids.has(id):
				player += 1
	return {"friend": friend, "enemy": enemy, "player": player}


## Check if a given point is withn a shape.
## [param p] Point to check.
## [param center_m] Area center.
## [param size] Area size.
## [param shape] Area shape.
## [return] True if point is inside shape.
func _point_in_shape(
	p: Vector2, center_m: Vector2, size_m: Vector2, shape: ScenarioTrigger.AreaShape
) -> bool:
	match shape:
		ScenarioTrigger.AreaShape.CIRCLE:
			var r: float = max(size_m.x, size_m.y) * 0.5
			return p.distance_to(center_m) <= r
		_:
			var half := size_m * 0.5
			var minp := center_m - half
			var maxp := center_m + half
			return p.x >= minp.x and p.x <= maxp.x and p.y >= minp.y and p.y <= maxp.y


## Get a unit snapshot.
## [param id_or_callsign] ID or Callsign of unit.
## [return] {id, callsign, pos_m: Vector2, aff: int} or {}.
func get_unit_snapshot(id_or_callsign: String) -> Dictionary:
	var id := id_or_callsign
	if not _snap_by_id.has(id):
		id = _id_by_callsign.get(id_or_callsign, "")
	return _snap_by_id.get(id, {})


## Count of units in an area.
## [param affiliation] Affiliation to filter for.
## [param center_m] Center of area
## [param size_m] Size of area.
## [param shape] Shape of area (rect or circle).
## [return] a dictionary of unit counts by affiliation.
func count_in_area(
	affiliation: String, center_m: Vector2, size_m: Vector2, shape: String = "rect"
) -> int:
	return units_in_area(affiliation, center_m, size_m, shape).size()


## Units in an area.
## [param affiliation] Affiliation to filter for.
## [param center_m] Center of area
## [param size_m] Size of area.
## [param shape] Shape of area (rect or circle).
## [return] a dictionary of unit counts by affiliation.
func units_in_area(
	affiliation: String, center_m: Vector2, size_m: Vector2, shape: String = "rect"
) -> Array:
	var shape_enum := (
		ScenarioTrigger.AreaShape.RECT
		if shape.to_lower() != "circle"
		else ScenarioTrigger.AreaShape.CIRCLE
	)
	var out := []
	for id in _snap_by_id.keys():
		var s: Dictionary = _snap_by_id[id]
		var pos: Vector2 = s.get("pos_m", Vector2.ZERO)
		if not _point_in_shape(pos, center_m, size_m, shape_enum):
			continue
		var aff := int(s.get("aff", 0))
		var is_player := _player_ids.has(id)
		match affiliation.to_lower():
			"friend":
				if aff == 0:
					out.append(s)
			"enemy":
				if aff != 0:
					out.append(s)
			"player":
				if is_player:
					out.append(s)
			"any":
				out.append(s)
			_:
				pass
	return out


## Handle raw radio command from Radio node.
func _on_radio_raw(text: String) -> void:
	_last_radio_text = text
	_api._set_last_radio_command(text)


## Manually activate a trigger by ID.
## Forces a trigger to become active and run its on_activate expression.
## Used by custom voice commands to fire specific triggers.
## [param trigger_id] ID of the trigger to activate.
## [return] True if trigger was found and activated.
func activate_trigger(trigger_id: String) -> bool:
	if not _scenario:
		return false
	for t in _scenario.triggers:
		if t.id == trigger_id and not t._active:
			t._active = true
			var ctx := _make_ctx(t, false)
			_vm.run(t.on_activate_expr, ctx)
			LogService.trace("Manually activated trigger: %s" % trigger_id, "TriggerEngine.gd")
			return true
	return false


## Get a global variable value shared across all triggers.
## [param key] Variable name.
## [param default] Default value if variable doesn't exist.
## [return] Variable value or default.
func get_global(key: String, default: Variant = null) -> Variant:
	return _globals.get(key, default)


## Set a global variable value shared across all triggers.
## [param key] Variable name.
## [param value] Value to store.
func set_global(key: String, value: Variant) -> void:
	_globals[key] = value


## Check if a global variable exists.
## [param key] Variable name.
## [return] True if variable exists.
func has_global(key: String) -> bool:
	return _globals.has(key)


## Clear all global variables.
func clear_globals() -> void:
	_globals.clear()


## Execute an expression immediately (used by dialog blocking).
## [param expr] Expression to execute.
## [param ctx] Context dictionary for the expression.
func execute_expression(expr: String, ctx: Dictionary) -> void:
	if _vm:
		_vm.run(expr, ctx)


## Schedule an action to execute after a delay.
## [param delay_s] Delay in seconds before execution.
## [param expr] Expression to execute.
## [param ctx] Context dictionary for the expression.
## [param use_realtime] If true, uses real-time instead of mission time.
func schedule_action(
	delay_s: float, expr: String, ctx: Dictionary, use_realtime: bool = false
) -> void:
	if not _sim and not use_realtime:
		push_warning(
			"TriggerEngine: Cannot schedule mission-time action without SimWorld reference"
		)
		return

	var execute_at: float
	if use_realtime:
		execute_at = _realtime_accumulator + delay_s
	else:
		execute_at = _sim.get_mission_time_s() + delay_s

	_scheduled_actions.append(
		{"execute_at": execute_at, "expr": expr, "ctx": ctx, "use_realtime": use_realtime}
	)


## Process mission-time scheduled actions that are ready to execute.
func _process_mission_time_actions() -> void:
	if not _sim:
		return
	var current_time := _sim.get_mission_time_s()
	var remaining: Array = []

	for action in _scheduled_actions:
		# Only process mission-time actions
		if not action.use_realtime:
			if action.execute_at <= current_time:
				# Execute the action
				_vm.run(action.expr, action.ctx)
			else:
				# Keep for later
				remaining.append(action)
		else:
			# Keep real-time actions for _process_realtime_actions
			remaining.append(action)

	_scheduled_actions = remaining


## Process real-time scheduled actions that are ready to execute.
func _process_realtime_actions() -> void:
	var current_time := _realtime_accumulator
	var remaining: Array = []

	for action in _scheduled_actions:
		# Only process real-time actions
		if action.use_realtime:
			if action.execute_at <= current_time:
				# Execute the action
				_vm.run(action.expr, action.ctx)
			else:
				# Keep for later
				remaining.append(action)
		else:
			# Keep mission-time actions for _process_mission_time_actions
			remaining.append(action)

	_scheduled_actions = remaining
