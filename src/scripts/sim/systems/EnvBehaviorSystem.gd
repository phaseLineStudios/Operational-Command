class_name EnvBehaviorSystem
extends Node
## Computes visibility, loss rolls, and terrain slowdowns; ticks navigation states.
## Stub only—implement behaviour, signals, and integrations in a later task.

# Signals (documented in task):
signal unit_lost(unit_id: String)
signal unit_recovered(unit_id: String)
signal unit_bogged(unit_id: String)
signal unit_unbogged(unit_id: String)
signal speed_modifier_changed(unit_id: String, multiplier: float)
signal navigation_bias_changed(unit_id: String, bias: StringName)

# TODO: add exports for TerrainRender/LOSAdapter/VisibilityProfile/MovementAdapter/SimWorld RNG, etc.


## Register units and attach navigation state.
func register_units(units: Array) -> void:
	pass


## Unregister a single unit.
func unregister_unit(unit_id: String) -> void:
	pass


## Main tick entry: update per-unit env behaviour.
func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void:
	pass


## Apply navigation bias change request (roads/cover/shortest).
func set_navigation_bias(unit_id: String, bias: StringName) -> void:
	pass


## Compute visibility at a position for loss calculations.
func _compute_visibility_score(unit: Variant) -> float:
	pass


## Determine path complexity/risk for a unit.
func _estimate_path_complexity(unit: Variant) -> float:
	pass


## Evaluate and update lost state for a unit.
func _update_lost_state(unit: Variant, visibility: float, rng: RandomNumberGenerator) -> void:
	pass


## Evaluate and update slowdown/bog states for a unit.
func _update_slowdown_state(unit: Variant, rng: RandomNumberGenerator) -> void:
	pass


## Broadcast speed multiplier changes downstream.
func _emit_speed_change(unit_id: String, mult: float) -> void:
	pass
