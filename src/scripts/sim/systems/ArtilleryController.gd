class_name ArtilleryController
extends Node
## Manages artillery and mortar fire missions.
##
## Responsibilities:
## - Identify artillery-capable units from equipment
## - Process fire mission orders (position, ammo type, rounds)
## - Simulate projectile flight time and impact
## - Emit signals for voice responses (confirm, shot, splash, impact)
## - Generate battle damage assessments from observer units

## Emitted when a fire mission is confirmed/accepted
signal mission_confirmed(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
## Emitted when rounds are fired ("Shot")
signal rounds_shot(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
## Emitted 5 seconds before impact ("Splash")
signal rounds_splash(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
## Emitted when rounds impact
signal rounds_impact(
	unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int, damage: float
)
## Emitted when friendly observers provide BDA
signal battle_damage_assessment(observer_id: String, target_pos: Vector2, description: String)

## Artillery ammunition types
enum ArtilleryAmmoType { AP, SMOKE, ILLUM }


## Active fire mission data
class FireMission:
	var unit_id: String
	var target_pos: Vector2
	var ammo_type: String
	var rounds: int
	var flight_time: float
	var time_elapsed: float = 0.0
	var shot_called: bool = false
	var splash_called: bool = false

	func _init(
		p_unit_id: String,
		p_target_pos: Vector2,
		p_ammo_type: String,
		p_rounds: int,
		p_flight_time: float
	):
		unit_id = p_unit_id
		target_pos = p_target_pos
		ammo_type = p_ammo_type
		rounds = p_rounds
		flight_time = p_flight_time


## Flight time calculation parameters
@export var mortar_flight_time_base: float = 15.0  ## Base flight time for mortars (seconds)
@export var artillery_flight_time_base: float = 25.0  ## Base flight time for artillery (seconds)
@export var splash_warning_time: float = 5.0  ## Time before impact to call "Splash"

## Damage parameters
@export var ap_damage_per_round: float = 10.0  ## Base damage per AP/HE round
@export var ap_damage_radius_m: float = 50.0  ## Damage radius for AP rounds

var _units: Dictionary = {}  ## unit_id -> UnitData
var _positions: Dictionary = {}  ## unit_id -> Vector2 (terrain meters)
var _artillery_units: Dictionary = {}  ## unit_id -> bool (is artillery capable)
var _active_missions: Array[FireMission] = []
var _ammo_system: AmmoSystem = null
var _los_adapter: LOSAdapter = null


func _ready() -> void:
	add_to_group("ArtilleryController")


## Register a unit and check if it's artillery-capable.
## [param unit_id] The ScenarioUnit ID (with SLOT suffix if applicable).
## [param u] The UnitData to register.
func register_unit(unit_id: String, u: UnitData) -> void:
	_units[unit_id] = u
	var is_arty: bool = _is_artillery_unit(u)
	_artillery_units[unit_id] = is_arty


## Unregister a unit
func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_artillery_units.erase(unit_id)
	# Cancel any active missions from this unit
	for i in range(_active_missions.size() - 1, -1, -1):
		if _active_missions[i].unit_id == unit_id:
			_active_missions.remove_at(i)


## Update unit position
func set_unit_position(unit_id: String, pos: Vector2) -> void:
	_positions[unit_id] = pos


## Bind external systems
func bind_ammo_system(ammo_sys: AmmoSystem) -> void:
	_ammo_system = ammo_sys


func bind_los_adapter(los: LOSAdapter) -> void:
	_los_adapter = los


## Check if a unit is artillery-capable
func is_artillery_unit(unit_id: String) -> bool:
	return _artillery_units.get(unit_id, false)


## Get available artillery ammunition types for a unit
func get_available_ammo_types(unit_id: String) -> Array[String]:
	var u: UnitData = _units.get(unit_id)
	if not u:
		return []

	var types: Array[String] = []

	# Check for mortar ammo
	if u.state_ammunition.get("MORTAR_AP", 0) > 0:
		types.append("MORTAR_AP")
	if u.state_ammunition.get("MORTAR_SMOKE", 0) > 0:
		types.append("MORTAR_SMOKE")
	if u.state_ammunition.get("MORTAR_ILLUM", 0) > 0:
		types.append("MORTAR_ILLUM")

	# Check for artillery ammo
	if u.state_ammunition.get("ARTILLERY_AP", 0) > 0:
		types.append("ARTILLERY_AP")
	if u.state_ammunition.get("ARTILLERY_SMOKE", 0) > 0:
		types.append("ARTILLERY_SMOKE")
	if u.state_ammunition.get("ARTILLERY_ILLUM", 0) > 0:
		types.append("ARTILLERY_ILLUM")

	return types


## Request a fire mission from an artillery unit
## Returns true if accepted, false if unable to comply
func request_fire_mission(
	unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int = 1
) -> bool:
	var u: UnitData = _units.get(unit_id)
	if not u:
		LogService.warning("Fire mission failed: unit not found", "ArtilleryController")
		return false

	if not _artillery_units.get(unit_id, false):
		LogService.warning("Fire mission failed: unit not artillery", "ArtilleryController")
		return false

	# Check if unit has ammo
	var current_ammo: int = u.state_ammunition.get(ammo_type, 0)
	if current_ammo < rounds:
		LogService.warning(
			"Fire mission failed: insufficient ammo (%d/%d)" % [current_ammo, rounds],
			"ArtilleryController"
		)
		return false

	# Consume ammo if AmmoSystem is available
	# AmmoSystem uses UnitData IDs (without SLOT suffix)
	if _ammo_system:
		for i in rounds:
			if not _ammo_system.consume(u.id, ammo_type, 1):
				LogService.warning(
					"Fire mission ammo consumption failed for %s" % u.id, "ArtilleryController"
				)
				return false

	# Calculate flight time based on ammo type
	var is_mortar: bool = ammo_type.begins_with("MORTAR_")
	var base_flight_time: float = (
		mortar_flight_time_base if is_mortar else artillery_flight_time_base
	)

	# Create fire mission
	var mission := FireMission.new(unit_id, target_pos, ammo_type, rounds, base_flight_time)
	_active_missions.append(mission)

	# Emit confirmation signal
	LogService.debug(
		"Emitting mission_confirmed for %s" % unit_id, "ArtilleryController"
	)
	emit_signal("mission_confirmed", unit_id, target_pos, ammo_type, rounds)

	LogService.info(
		"Fire mission: %s firing %d x %s at %s" % [unit_id, rounds, ammo_type, target_pos],
		"ArtilleryController"
	)

	return true


## Tick active fire missions
func tick(delta: float) -> void:
	for i in range(_active_missions.size() - 1, -1, -1):
		var mission: FireMission = _active_missions[i]
		mission.time_elapsed += delta

		# Call "Shot" once at the start
		if not mission.shot_called:
			LogService.debug(
				"Emitting rounds_shot for %s" % mission.unit_id, "ArtilleryController"
			)
			emit_signal(
				"rounds_shot",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.rounds
			)
			mission.shot_called = true

		# Call "Splash" before impact
		if (
			not mission.splash_called
			and mission.time_elapsed >= mission.flight_time - splash_warning_time
		):
			emit_signal(
				"rounds_splash",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.rounds
			)
			mission.splash_called = true

		# Impact
		if mission.time_elapsed >= mission.flight_time:
			_process_impact(mission)
			_active_missions.remove_at(i)


## Process round impacts and generate damage/BDA
func _process_impact(mission: FireMission) -> void:
	var damage: float = 0.0

	# Calculate damage for AP rounds
	if mission.ammo_type.ends_with("_AP"):
		damage = ap_damage_per_round * mission.rounds
		# TODO: Apply damage to units in radius

	# Emit impact signal
	emit_signal(
		"rounds_impact",
		mission.unit_id,
		mission.target_pos,
		mission.ammo_type,
		mission.rounds,
		damage
	)

	# Generate BDA from nearby friendly observers
	_generate_bda(mission)


## Generate battle damage assessment from observer units
func _generate_bda(mission: FireMission) -> void:
	# Find friendly units near the impact point that can observe
	# Uses distance-based checks (artillery impacts are highly visible)
	for unit_id in _units.keys():
		var u: UnitData = _units[unit_id]
		if not u:
			continue

		# Skip the firing unit
		if unit_id == mission.unit_id:
			continue

		var pos: Vector2 = _positions.get(unit_id, Vector2.INF)
		if pos == Vector2.INF:
			continue

		# Check if within spotting range (artillery impacts are visible at distance)
		var distance: float = pos.distance_to(mission.target_pos)
		if distance > u.spot_m:
			continue

		# Generate BDA from first observer in range
		var description := _generate_bda_description(mission)
		emit_signal("battle_damage_assessment", unit_id, mission.target_pos, description)
		# Only one BDA per mission
		break


## Generate BDA description based on mission type
func _generate_bda_description(mission: FireMission) -> String:
	if mission.ammo_type.ends_with("_AP"):
		return "Rounds on target, good effect."
	elif mission.ammo_type.ends_with("_SMOKE"):
		return "Smoke deployed, obscuring target area."
	elif mission.ammo_type.ends_with("_ILLUM"):
		return "Illumination rounds deployed, area lit."
	return "Rounds impacted."


## Check if unit has artillery/mortar ammunition
func _is_artillery_unit(u: UnitData) -> bool:
	if not u.equipment or not u.equipment.has("weapons"):
		return false

	var weapons: Dictionary = u.equipment.get("weapons", {})
	for weapon_name in weapons.keys():
		var weapon_data: Dictionary = weapons[weapon_name]
		var ammo_type_index: int = int(weapon_data.get("ammo", -1))

		# Check if ammo type is mortar or artillery (indices 6-11)
		if ammo_type_index >= 6 and ammo_type_index <= 11:
			return true

	return false
