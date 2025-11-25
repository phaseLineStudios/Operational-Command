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
	pass


## Mark unit as lost with an optional drift vector.
func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void:
	pass


## Set bogged/slow state and timers.
func set_nav_state(state: NavState) -> void:
	pass


## Advance timers for lost/bogged state.
func tick_timers(dt: float) -> void:
	pass


## Update navigation bias preference.
func set_navigation_bias(bias: StringName) -> void:
	pass
