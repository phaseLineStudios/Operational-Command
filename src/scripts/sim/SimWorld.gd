extends Node
## Authoritative battlefield simulation (state, movement, combat, LOS).
##
## Holds all unit entities and resolves ticks deterministically. Integrates
## visibility LOS.gd and combat Combat.gd and
## exposes read-only views for UI.
##
## Ammo integration:
## - Owns a mission-scoped `AmmoSystem` child.
## - Feeds delta-time via `_physics_process`.
## - Provides `on_unit_position(...)` for movement code to push positions.
## - (Optionally) binds `RadioFeedback` to ammo events.

## Central mission-scoped AmmoSystem instance. Created at runtime here.
@onready var _ammo: AmmoSystem = AmmoSystem.new()
@onready var _adapter: CombatAdapter = CombatAdapter.new()

## Initialize a new FuelSystem
@onready var _fuel: FuelSystem = FuelSystem.new()


## Create and configure AmmoSystem; optionally hook up RadioFeedback.
func _ready() -> void:
	add_child(_ammo)
	_ammo.ammo_profile = preload("res://data/ammo/default_caps.tres")

	add_child(_adapter)
	_adapter.add_to_group("CombatAdapter")
	_adapter.ammo_system_path = _ammo.get_path()
	# Register units once roster is ready (left commented for now; call from roster code):
	# for u in _current_units:
	#	_ammo.register_unit(u)
	#	su.bind_fuel_system(_fuel)

	# Fuel System
	add_child(_fuel)

	# Optional radio hookup (if a RadioFeedback node exists in the scene).
	var radio := get_tree().get_first_node_in_group("RadioFeedback") as RadioFeedback
	if radio:
		radio.bind_ammo(_ammo)
		radio.bind_fuel(_fuel)

	Game.start_scenario([])


## Drive AmmoSystem every frame so in-field resupply progresses over time.
func _physics_process(delta: float) -> void:
	_ammo.tick(delta)
	_fuel.tick(delta)


## Movement hook: call from movement/controller code whenever a unit moves.
## `pos` is world-space (meters). For 2D maps, use Vector3(x, 0, y).
func on_unit_position(uid: String, pos: Vector3) -> void:
	_ammo.set_unit_position(uid, pos)
	# Not needed for ScenarioUnit-based Fuel consumption, which reads su.position_m,
	# but keep this if we later want to support MovementAgent-driven units for fuel too.
	
## Return a strength factor in [0,1] derived from UnitData.state_strength and UnitData.strength.
func compute_strength_factor(u: UnitData) -> float:
	var cap: float = float(max(1, u.strength))
	var cur: float = float(max(0.0, u.state_strength))
	if cur <= 0.0:
		return 0.0
	return clamp(cur / cap, 0.0, 1.0)

## True if the unit should be spawned in the mission.
func should_spawn_unit(u: UnitData) -> bool:
	return u != null and u.state_strength > 0.0

## Optionally filter a list of ScenarioUnit before spawning.
## Can be used to filter out any units that are already wiped out
func filter_spawnable(units: Array) -> Array:
	var out: Array = []
	for su in units:
		if su is ScenarioUnit and su.unit and should_spawn_unit(su.unit):
			out.append(su)
	return out

## Spawn ScenarioUnits into the sim; skips wiped-out and forwards strength_factor.
func spawn_scenario_units(scenario) -> void:
	if scenario == null:
		return

	# Use instance methods here (not SimWorld.*)
	var spawn_list: Array = filter_spawnable(scenario.units)

	for su in spawn_list:
		if su == null or su.unit == null or su.packed_scene == null:
			continue

		var u: UnitData = su.unit
		var f: float = compute_strength_factor(u)  # 0..1, 0 if wiped out

		var inst: Node = su.packed_scene.instantiate()
		add_child(inst)

		# Forward strength into the instance
		if inst.has_method("apply_strength_factor"):
			inst.apply_strength_factor(f)
		elif inst.has_variable("strength_factor"):
			inst.strength_factor = f

		# (Optional) scale counts if your unit scene supports it
		if inst.has_variable("base_count") and inst.has_variable("count"):
			if f <= 0.0:
				inst.count = 0
			else:
				inst.count = max(1, int(round(inst.base_count * f)))
