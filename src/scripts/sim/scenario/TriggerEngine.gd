class_name TriggerEngine
extends Node
## Deterministic evaluator for ScenarioTrigger resources.
## Combines presence checks with a sandboxed condition VM and executes actions.

## SimWorld for time and snapshots
@export var _sim: SimWorld
## If false, call tick(dt) manually from SimWorld
@export var run_in_process := false

var _scenario: ScenarioData
var _res: MissionResolution
var _vm := TriggerVM.new()
var _api := TriggerAPI.new()
var _snap_by_id: Dictionary = {}
var _id_by_callsign: Dictionary = {}
var _player_ids := {}


## Wire API.
func _ready() -> void:
	_api.sim = _sim
	_api.res = _res
	_api.engine = self
	_vm.set_api(_api)
	set_process(run_in_process)


## Tick triggers independently.
func _process(dt: float) -> void:
	if run_in_process:
		tick(dt)


## Bind scenario to engine.
## [param scenario] Current scenario.
func bind_scenario(scenario: ScenarioData) -> void:
	_scenario = scenario


## Deterministic evaluation entry point.
## [param dt] delta time from last tick.
func tick(dt: float) -> void:
	_refresh_unit_indices()
	for t in _scenario.triggers:
		_evaluate_trigger(t, dt)


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
	return {
		"trigger_id": t.id,
		"title": t.title,
		"center": t.area_center_m,
		"size": t.area_size_m,
		"presence_ok": presence_ok,
		"count_friend": counts.friend,
		"count_enemy": counts.enemy,
		"count_player": counts.player,
	}


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
