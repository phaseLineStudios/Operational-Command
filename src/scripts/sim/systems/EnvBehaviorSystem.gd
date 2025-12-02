class_name EnvBehaviorSystem
extends Node
## Computes visibility, loss rolls, and terrain slowdowns; ticks navigation states.
## Deterministic behaviour depends on an external RNG provided by the caller.

# Signals (documented in task):
signal unit_lost(unit_id: String)
signal unit_recovered(unit_id: String)
signal unit_bogged(unit_id: String)
signal unit_unbogged(unit_id: String)
signal speed_modifier_changed(unit_id: String, multiplier: float)
signal navigation_bias_changed(unit_id: String, bias: StringName)

@export var movement_adapter: MovementAdapter
@export var los_adapter: LOSAdapter
@export var visibility_profile: VisibilityProfile
@export var default_speed_mult_slowed: float = 0.8
@export var default_speed_mult_bogged: float = 0.4
@export var loss_threshold: float = 0.5
@export var regroup_recovery_bonus: float = 0.2  ## bonus visibility when Hold/Regroup is active
@export var landmark_recovery_radius_m: float = 25.0

var _nav_state_by_id: Dictionary = {}  ## unit_id -> UnitNavigationState
var _speed_mult_cache: Dictionary = {}  ## unit_id -> float


## Register units and attach navigation state.
func register_units(units: Array) -> void:
	for su in units:
		if su == null:
			continue
		var uid := String(su.id)
		if uid == "":
			continue
		# Force ALPHA to start in CARELESS for testing.
		if su.callsign.to_upper() == "ALPHA":
			su.behaviour = ScenarioUnit.Behaviour.CARELESS
		if not _nav_state_by_id.has(uid):
			_nav_state_by_id[uid] = UnitNavigationState.new()


## Unregister a single unit.
func unregister_unit(unit_id: String) -> void:
	_nav_state_by_id.erase(unit_id)
	_speed_mult_cache.erase(unit_id)


## Main tick entry: update per-unit env behaviour.
func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void:
	if rng == null:
		return
	for su in units:
		if su == null or su.is_dead():
			continue
		var uid := String(su.id)
		var nav: UnitNavigationState = _nav_state_by_id.get(uid, null)
		if nav == null:
			nav = UnitNavigationState.new()
			_nav_state_by_id[uid] = nav

		nav.tick_timers(dt)

		var vis: float = _compute_visibility_score(su, scenario)
		_update_lost_state(su, nav, vis, rng, scenario)
		_update_slowdown_state(su, nav, rng)


## Apply navigation bias change request (roads/cover/shortest).
func set_navigation_bias(unit_id: String, bias: StringName) -> void:
	var nav: UnitNavigationState = _nav_state_by_id.get(unit_id, null)
	if nav == null:
		return
	if nav.navigation_bias == bias:
		return
	nav.set_navigation_bias(bias)
	if movement_adapter and movement_adapter.has_method("set_navigation_bias"):
		movement_adapter.set_navigation_bias(_find_unit_by_id(unit_id), bias)
	emit_signal("navigation_bias_changed", unit_id, bias)


## Compute visibility at a position for loss calculations.
func _compute_visibility_score(unit: Variant, scenario: Variant) -> float:
	var pos_m: Vector2 = unit.position_m if "position_m" in unit else Vector2.ZERO
	if visibility_profile and movement_adapter and movement_adapter.renderer:
		return visibility_profile.compute_visibility_score(
			movement_adapter.renderer, pos_m, scenario, int(unit.behaviour)
		)
	if visibility_profile and los_adapter:
		return visibility_profile.compute_visibility_score(
			los_adapter, pos_m, scenario, int(unit.behaviour)
		)
	if los_adapter and los_adapter.has_method("sample_visibility_at"):
		return los_adapter.sample_visibility_at(pos_m)
	return 1.0


## Determine path complexity/risk for a unit.
func _estimate_path_complexity(unit: Variant) -> float:
	if unit == null or not unit.has_method("current_path"):
		return 0.0
	var path: PackedVector2Array = unit.current_path()
	if path.is_empty():
		return 0.0
	# Simple heuristic: longer paths and more turns increase complexity.
	var total_len: float = 0.0
	var turn_sum: float = 0.0
	for i in range(1, path.size()):
		total_len += path[i - 1].distance_to(path[i])
		if i >= 2:
			var a := (path[i - 1] - path[i - 2]).normalized()
			var b := (path[i] - path[i - 1]).normalized()
			var dot: float = clamp(a.dot(b), -1.0, 1.0)
			var turn: float = acos(dot)
			turn_sum += turn
	var norm_len: float = clamp(total_len / 1000.0, 0.0, 1.0)
	var norm_turns: float = clamp(turn_sum / PI, 0.0, 1.0)
	return clamp((norm_len * 0.6) + (norm_turns * 0.4), 0.0, 1.0)


## Evaluate and update lost state for a unit.
func _update_lost_state(
	unit: Variant,
	nav: UnitNavigationState,
	visibility: float,
	rng: RandomNumberGenerator,
	scenario: Variant
) -> void:
	var uid := String(unit.id)
	var path_complexity: float = _estimate_path_complexity(unit)
	var threshold: float = loss_threshold
	if _has_hold_regroup_order(unit):
		visibility += regroup_recovery_bonus

	# Recovery: regain when visibility improves or after some time.
	if nav.is_lost:
		if (
			visibility >= threshold
			or nav.lost_timer_s > 30.0
			or _has_friendly_los(unit)
			or _near_landmark(unit)
		):
			nav.set_lost(false)
			_apply_drift(uid, Vector2.ZERO)
			_emit_speed_change(uid, 1.0)
			_request_repath(uid)
			emit_signal("unit_recovered", uid)
			return
		nav.set_lost(true, nav.drift_vector)  # keep timer running
		_apply_drift(uid, nav.drift_vector)
		return

	# Chance to become lost when visibility is low and path is complex.
	var loss_risk: float = clamp(threshold - visibility, 0.0, 1.0) * (0.5 + path_complexity * 0.5)
	loss_risk *= _terrain_loss_factor(unit)
	loss_risk *= _behaviour_loss_factor(unit)
	loss_risk *= _weather_loss_factor(scenario)
	if loss_risk <= 0.0:
		return
	if rng.randf() < loss_risk:
		nav.set_lost(true, _random_drift(rng))
		_apply_drift(uid, nav.drift_vector)
		_emit_speed_change(uid, default_speed_mult_slowed)
		_request_repath(uid)
		LogService.info(
			"Unit %s lost (risk=%.2f vis=%.2f)" % [uid, loss_risk, visibility],
			"EnvBehaviorSystem.gd"
		)
		emit_signal("unit_lost", uid)


## Evaluate and update slowdown/bog states for a unit.
func _update_slowdown_state(
	unit: Variant, nav: UnitNavigationState, rng: RandomNumberGenerator
) -> void:
	var uid := String(unit.id)

	# If stuck soft, leave handling to engineer flow; do not auto-recover here.
	if nav.nav_state == UnitNavigationState.NavState.STUCK_SOFT:
		return

	# Recover from bogged/slowed over time.
	if nav.nav_state in [UnitNavigationState.NavState.SLOWED, UnitNavigationState.NavState.BOGGED]:
		if nav.nav_state == UnitNavigationState.NavState.BOGGED and nav.bogged_timer_s > 20.0:
			_set_stuck_soft(uid, nav)
			return
		if nav.bogged_timer_s > 10.0 and rng.randf() < 0.25:
			nav.set_nav_state(UnitNavigationState.NavState.NORMAL)
			nav.bogged_timer_s = 0.0
			_emit_speed_change(uid, 1.0)
			_request_repath(uid)
			emit_signal("unit_unbogged", uid)
		return

	# Simple bogging probability: small per tick, biased by path complexity.
	var bog_risk := _estimate_path_complexity(unit) * 0.1
	bog_risk *= _terrain_bog_factor(unit)
	if bog_risk <= 0.0:
		return
	if rng.randf() < bog_risk:
		nav.set_nav_state(UnitNavigationState.NavState.BOGGED)
		nav.bogged_timer_s = 0.0
		_emit_speed_change(uid, default_speed_mult_bogged)
		_request_repath(uid)
		LogService.info("Unit %s bogged down" % uid, "EnvBehaviorSystem.gd")
		emit_signal("unit_bogged", uid)


## Broadcast speed multiplier changes downstream.
func _emit_speed_change(unit_id: String, mult: float) -> void:
	var prev: float = _speed_mult_cache.get(unit_id, 1.0)
	if is_equal_approx(prev, mult):
		return
	_speed_mult_cache[unit_id] = mult
	if movement_adapter and movement_adapter.has_method("set_env_speed_multiplier"):
		movement_adapter.set_env_speed_multiplier(_find_unit_by_id(unit_id), mult)
	emit_signal("speed_modifier_changed", unit_id, mult)


## Find a ScenarioUnit by id in the current scenario.
func _find_unit_by_id(unit_id: String) -> ScenarioUnit:
	if Game.current_scenario == null:
		return null
	for su in Game.current_scenario.units:
		if su != null and String(su.id) == unit_id:
			return su
	for su2 in Game.current_scenario.playable_units:
		if su2 != null and String(su2.id) == unit_id:
			return su2
	return null


func _random_drift(rng: RandomNumberGenerator) -> Vector2:
	var angle: float = rng.randf_range(0.0, PI * 2.0)
	var magnitude: float = rng.randf_range(0.5, 2.0)
	return Vector2.RIGHT.rotated(angle) * magnitude


## Terrain multiplier for bog risk based on path grid weight.
func _terrain_bog_factor(unit: ScenarioUnit) -> float:
	if movement_adapter == null or movement_adapter.renderer == null:
		return 1.0
	var pg: PathGrid = movement_adapter.renderer.path_grid
	if pg == null:
		return 1.0
	var c := pg.world_to_cell(unit.position_m)
	if not pg._in_bounds(c):
		return 1.0
	if pg._astar and pg._astar.is_in_boundsv(c):
		var w: float = max(pg._astar.get_point_weight_scale(c), 0.001)
		# Heavier weights (mud/soft ground) increase bog risk; roads (w<1) reduce it.
		return clamp(w, 0.5, 2.0)
	return 1.0


func _terrain_loss_factor(unit: ScenarioUnit) -> float:
	if movement_adapter == null or movement_adapter.renderer == null:
		return 1.0
	var pg: PathGrid = movement_adapter.renderer.path_grid
	if pg == null:
		return 1.0
	var c := pg.world_to_cell(unit.position_m)
	if not pg._in_bounds(c):
		return 1.0
	if pg._astar and pg._astar.is_in_boundsv(c):
		var w: float = max(pg._astar.get_point_weight_scale(c), 0.001)
		# Dense/rough terrain increases loss risk slightly; roads reduce it.
		return clamp(0.8 + (w - 1.0) * 0.2, 0.5, 1.5)
	return 1.0


func _has_hold_regroup_order(unit: ScenarioUnit) -> bool:
	return unit != null and unit.has_meta("hold_regroup")


## Behaviour profile influence on getting lost.
func _behaviour_loss_factor(unit: ScenarioUnit) -> float:
	if unit == null:
		return 1.0
	match unit.behaviour:
		ScenarioUnit.Behaviour.CARELESS:
			return 1.25
		ScenarioUnit.Behaviour.SAFE:
			return 1.0
		ScenarioUnit.Behaviour.AWARE:
			return 0.9
		ScenarioUnit.Behaviour.COMBAT:
			return 0.85
		ScenarioUnit.Behaviour.STEALTH:
			return 0.7
		_:
			return 1.0


## Weather severity influence on loss risk.
func _weather_loss_factor(scenario: Variant) -> float:
	if visibility_profile == null:
		return 1.0
	var sev := visibility_profile.weather_severity_from_scenario(scenario)
	return clamp(1.0 + sev * 0.5, 0.5, 1.5)


## Recovery helper: detect nearby map labels as landmarks.
func _near_landmark(unit: ScenarioUnit) -> bool:
	if movement_adapter == null or movement_adapter.renderer == null:
		return false
	if unit == null:
		return false
	var data := movement_adapter.renderer.data
	if data == null or data.labels == null:
		return false
	for lab in data.labels:
		if typeof(lab) != TYPE_DICTIONARY:
			continue
		var pos: Variant = lab.get("pos", null)
		if typeof(pos) != TYPE_VECTOR2:
			continue
		if (pos as Vector2).distance_to(unit.position_m) <= landmark_recovery_radius_m:
			return true
	return false


## True if any friendly has LOS to this unit.
func _has_friendly_los(unit: ScenarioUnit) -> bool:
	if los_adapter == null or Game.current_scenario == null or unit == null:
		return false
	var all_units: Array = []
	all_units.append_array(Game.current_scenario.units)
	all_units.append_array(Game.current_scenario.playable_units)
	for other in all_units:
		if other == null or other == unit or other.is_dead():
			continue
		if other.affiliation != unit.affiliation:
			continue
		if los_adapter.has_los(other, unit) or los_adapter.has_los(unit, other):
			return true
	return false


## Ask movement adapter to rebuild the path for a unit.
func _request_repath(unit_id: String) -> void:
	if movement_adapter == null:
		return
	if not movement_adapter.has_method("request_env_repath"):
		return
	var su := _find_unit_by_id(unit_id)
	if su == null:
		return
	movement_adapter.request_env_repath(su)


## Mark a unit as stuck and halt movement until engineers assist.
func _set_stuck_soft(unit_id: String, nav: UnitNavigationState) -> void:
	nav.set_nav_state(UnitNavigationState.NavState.STUCK_SOFT)
	_emit_speed_change(unit_id, 0.0)
	LogService.warning(
		"Unit %s stuck in soft ground; engineer required" % unit_id, "EnvBehaviorSystem.gd"
	)
	emit_signal("unit_bogged", unit_id)


## Apply or clear drift metadata on the movement adapter.
func _apply_drift(unit_id: String, drift: Vector2) -> void:
	if movement_adapter == null:
		return
	var su := _find_unit_by_id(unit_id)
	if su == null:
		return
	if drift == Vector2.ZERO:
		if movement_adapter.has_method("clear_env_drift"):
			movement_adapter.clear_env_drift(su)
	else:
		if movement_adapter.has_method("set_env_drift"):
			movement_adapter.set_env_drift(su, drift)
