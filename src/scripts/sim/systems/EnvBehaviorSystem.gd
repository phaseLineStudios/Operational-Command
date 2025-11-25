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
		_update_lost_state(su, nav, vis, rng)
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
	unit: Variant, nav: UnitNavigationState, visibility: float, rng: RandomNumberGenerator
) -> void:
	var uid := String(unit.id)
	var path_complexity: float = _estimate_path_complexity(unit)
	var threshold: float = loss_threshold

	# Recovery: regain when visibility improves or after some time.
	if nav.is_lost:
		if visibility >= threshold or nav.lost_timer_s > 30.0:
			nav.set_lost(false)
			_emit_speed_change(uid, 1.0)
			emit_signal("unit_recovered", uid)
			return
		nav.set_lost(true, nav.drift_vector)  # keep timer running
		return

	# Chance to become lost when visibility is low and path is complex.
	var loss_risk: float = clamp(threshold - visibility, 0.0, 1.0) * (0.5 + path_complexity * 0.5)
	if loss_risk <= 0.0:
		return
	if rng.randf() < loss_risk:
		nav.set_lost(true, _random_drift(rng))
		_emit_speed_change(uid, default_speed_mult_slowed)
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
		if nav.bogged_timer_s > 10.0 and rng.randf() < 0.25:
			nav.set_nav_state(UnitNavigationState.NavState.NORMAL)
			nav.bogged_timer_s = 0.0
			_emit_speed_change(uid, 1.0)
			emit_signal("unit_unbogged", uid)
		return

	# Simple bogging probability: small per tick, biased by path complexity.
	var bog_risk := _estimate_path_complexity(unit) * 0.1
	if bog_risk <= 0.0:
		return
	if rng.randf() < bog_risk:
		nav.set_nav_state(UnitNavigationState.NavState.BOGGED)
		nav.bogged_timer_s = 0.0
		_emit_speed_change(uid, default_speed_mult_bogged)
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


func _find_unit_by_id(unit_id: String) -> ScenarioUnit:
	# Helper to find a ScenarioUnit in the current scenario if available.
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
