class_name UnitNavigationState
extends Resource
## Runtime navigation flags and timers for environment-aware movement.
## This is a stub; flesh out fields and helpers when implementing EnvBehaviorSystem.

enum NavState { NORMAL, SLOWED, BOGGED, STUCK_SOFT }

@export var nav_state: NavState = NavState.NORMAL
@export var is_lost: bool = false
@export var drift_vector: Vector2 = Vector2.ZERO
@export var lost_timer_s: float = 0.0
@export var bogged_timer_s: float = 0.0
@export var navigation_bias: StringName = &"shortest"  # roads/cover/shortest


## Reset all transient navigation flags.
func reset() -> void:
	nav_state = NavState.NORMAL
	is_lost = false
	drift_vector = Vector2.ZERO
	lost_timer_s = 0.0
	bogged_timer_s = 0.0
	navigation_bias = &"shortest"


## Mark unit as lost with an optional drift vector.
func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void:
	if state and not is_lost:
		lost_timer_s = 0.0
	is_lost = state
	drift_vector = drift if state else Vector2.ZERO
	if not state:
		lost_timer_s = 0.0


## Set bogged/slow state and timers.
func set_nav_state(state: NavState) -> void:
	if nav_state != state:
		if state == NavState.NORMAL:
			bogged_timer_s = 0.0
	nav_state = state


## Advance timers for lost/bogged state.
func tick_timers(dt: float) -> void:
	var clamped_dt := max(dt, 0.0)
	if is_lost:
		lost_timer_s += clamped_dt
	if nav_state in [NavState.SLOWED, NavState.BOGGED, NavState.STUCK_SOFT]:
		bogged_timer_s += clamped_dt


## Update navigation bias preference.
func set_navigation_bias(bias: StringName) -> void:
	navigation_bias = bias
