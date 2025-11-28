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
	var total_rounds: int
	var flight_time: float
	var shot_delay: float  ## Random delay before first shot
	var round_intervals: Array[float] = []  ## Delay for each round after the first
	var time_elapsed: float = 0.0
	var current_round: int = 0  ## Which round we're currently processing (0-based)
	var splash_called: bool = false

	func _init(
		p_unit_id: String,
		p_target_pos: Vector2,
		p_ammo_type: String,
		p_rounds: int,
		p_flight_time: float,
		p_shot_delay: float,
		p_round_intervals: Array[float]
	):
		unit_id = p_unit_id
		target_pos = p_target_pos
		ammo_type = p_ammo_type
		total_rounds = p_rounds
		flight_time = p_flight_time
		shot_delay = p_shot_delay
		round_intervals = p_round_intervals


## Flight time calculation parameters
@export var mortar_flight_time_base: float = 15.0  ## Base flight time for mortars (seconds)
@export var artillery_flight_time_base: float = 25.0  ## Base flight time for artillery (seconds)
@export var splash_warning_time: float = 5.0  ## Time before impact to call "Splash"

## Delay parameters
@export_range(0.0, 30.0, 0.1) var shot_delay_min: float = 2.0  ## Min delay from mission confirmed to first shot (seconds)
@export_range(0.0, 30.0, 0.1) var shot_delay_max: float = 5.0  ## Max delay from mission confirmed to first shot (seconds)
@export_range(0.0, 10.0, 0.1) var round_interval_min: float = 0.5  ## Min delay between rounds fired (seconds)
@export_range(0.0, 10.0, 0.1) var round_interval_max: float = 2.0  ## Max delay between rounds fired (seconds)
@export_range(0.0, 30.0, 0.1) var bda_delay_min: float = 3.0  ## Min delay from impact to BDA report (seconds)
@export_range(0.0, 30.0, 0.1) var bda_delay_max: float = 8.0  ## Max delay from impact to BDA report (seconds)

## Damage parameters
@export var ap_damage_per_round: float = 10.0  ## Base damage per AP/HE round
@export var ap_damage_radius_m: float = 50.0  ## Damage radius for AP rounds

var _units: Dictionary = {}  ## unit_id -> ScenarioUnit
var _positions: Dictionary = {}  ## unit_id -> Vector2 (terrain meters)
var _artillery_units: Dictionary = {}  ## unit_id -> bool (is artillery capable)
var _active_missions: Array[FireMission] = []
var _ammo_system: AmmoSystem = null
var _los_adapter: LOSAdapter = null
var _rng := RandomNumberGenerator.new()

## Pending BDA reports (delayed after impact)
var _pending_bda: Array[Dictionary] = []  ## [{observer_id, target_pos, description, time_remaining}]


func _ready() -> void:
	_rng.randomize()
	add_to_group("ArtilleryController")


## Register a unit and check if it's artillery-capable.
## [param unit_id] The ScenarioUnit ID (with SLOT suffix if applicable).
## [param su] The ScenarioUnit to register.
func register_unit(unit_id: String, su: ScenarioUnit) -> void:
	_units[unit_id] = su
	var is_arty: bool = _is_artillery_unit(su)
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

	# Cancel any pending BDA from this unit
	for i in range(_pending_bda.size() - 1, -1, -1):
		if _pending_bda[i]["observer_id"] == unit_id:
			_pending_bda.remove_at(i)


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
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		return []

	var types: Array[String] = []

	# Check for mortar ammo
	if su.state_ammunition.get("MORTAR_AP", 0) > 0:
		types.append("MORTAR_AP")
	if su.state_ammunition.get("MORTAR_SMOKE", 0) > 0:
		types.append("MORTAR_SMOKE")
	if su.state_ammunition.get("MORTAR_ILLUM", 0) > 0:
		types.append("MORTAR_ILLUM")

	# Check for artillery ammo
	if su.state_ammunition.get("ARTILLERY_AP", 0) > 0:
		types.append("ARTILLERY_AP")
	if su.state_ammunition.get("ARTILLERY_SMOKE", 0) > 0:
		types.append("ARTILLERY_SMOKE")
	if su.state_ammunition.get("ARTILLERY_ILLUM", 0) > 0:
		types.append("ARTILLERY_ILLUM")

	return types


## Request a fire mission from an artillery unit
## Returns true if accepted, false if unable to comply
func request_fire_mission(
	unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int = 1
) -> bool:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		LogService.warning("Fire mission failed: unit not found", "ArtilleryController")
		return false

	if not _artillery_units.get(unit_id, false):
		LogService.warning("Fire mission failed: unit not artillery", "ArtilleryController")
		return false

	# Check if unit has ammo
	var current_ammo: int = su.state_ammunition.get(ammo_type, 0)
	if current_ammo < rounds:
		LogService.warning(
			"Fire mission failed: insufficient ammo (%d/%d)" % [current_ammo, rounds],
			"ArtilleryController"
		)
		return false

	# Consume ammo if AmmoSystem is available
	# AmmoSystem uses ScenarioUnit IDs (with SLOT suffix if applicable)
	if _ammo_system:
		for i in rounds:
			if not _ammo_system.consume(unit_id, ammo_type, 1):
				LogService.warning(
					"Fire mission ammo consumption failed for %s" % unit_id, "ArtilleryController"
				)
				return false

	# Calculate flight time based on ammo type
	var is_mortar: bool = ammo_type.begins_with("MORTAR_")
	var base_flight_time: float = (
		mortar_flight_time_base if is_mortar else artillery_flight_time_base
	)

	# Generate random shot delay for first round
	var shot_delay: float = _rng.randf_range(shot_delay_min, shot_delay_max)

	# Generate random intervals between rounds
	var round_intervals: Array[float] = []
	for i in range(rounds - 1):  # We need rounds-1 intervals (between rounds)
		var interval := _rng.randf_range(round_interval_min, round_interval_max)
		round_intervals.append(interval)

	# Create fire mission
	var mission := FireMission.new(
		unit_id, target_pos, ammo_type, rounds, base_flight_time, shot_delay, round_intervals
	)
	_active_missions.append(mission)

	# Emit confirmation signal
	LogService.debug("Emitting mission_confirmed for %s" % unit_id, "ArtilleryController")
	emit_signal("mission_confirmed", unit_id, target_pos, ammo_type, rounds)

	LogService.info(
		"Fire mission: %s firing %d x %s at %s" % [unit_id, rounds, ammo_type, target_pos],
		"ArtilleryController"
	)

	return true


## Tick active fire missions
func tick(delta: float) -> void:
	# Process active fire missions
	for i in range(_active_missions.size() - 1, -1, -1):
		var mission: FireMission = _active_missions[i]
		mission.time_elapsed += delta

		# Process each round individually
		while mission.current_round < mission.total_rounds:
			var round_shot_time := _get_round_shot_time(mission, mission.current_round)
			var round_impact_time := round_shot_time + mission.flight_time

			# Check if it's time to fire this round
			if mission.time_elapsed >= round_shot_time:
				# Emit shot signal for this round
				LogService.debug(
					(
						"Emitting rounds_shot for %s (round %d/%d)"
						% [mission.unit_id, mission.current_round + 1, mission.total_rounds]
					),
					"ArtilleryController"
				)
				emit_signal(
					"rounds_shot", mission.unit_id, mission.target_pos, mission.ammo_type, 1
				)

				# Move to next round
				mission.current_round += 1
			else:
				# Haven't reached this round's shot time yet
				break

		# Call "Splash" warning before first impact
		if (
			not mission.splash_called
			and mission.current_round > 0
			and (
				mission.time_elapsed
				>= mission.shot_delay + mission.flight_time - splash_warning_time
			)
		):
			emit_signal(
				"rounds_splash",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.total_rounds
			)
			mission.splash_called = true

		# Check for impacts (process all rounds that should have impacted by now)
		var rounds_impacted := 0
		for round_idx in range(mission.total_rounds):
			var round_shot_time := _get_round_shot_time(mission, round_idx)
			var round_impact_time := round_shot_time + mission.flight_time

			if mission.time_elapsed >= round_impact_time:
				rounds_impacted += 1

		# Emit impact signals for any newly impacted rounds
		# We track how many have impacted before, so we only emit new ones
		var prev_impacted: float = mission.get_meta("prev_impacted", 0)
		if rounds_impacted > prev_impacted:
			for round_idx in range(prev_impacted, rounds_impacted):
				LogService.debug(
					(
						"Emitting rounds_impact for %s (round %d/%d)"
						% [mission.unit_id, round_idx + 1, mission.total_rounds]
					),
					"ArtilleryController"
				)
				emit_signal(
					"rounds_impact", mission.unit_id, mission.target_pos, mission.ammo_type, 1, 0.0
				)

			mission.set_meta("prev_impacted", rounds_impacted)

		# Mission complete when all rounds have impacted
		if rounds_impacted >= mission.total_rounds:
			_process_impact(mission)
			_active_missions.remove_at(i)

	# Process pending BDA reports
	for i in range(_pending_bda.size() - 1, -1, -1):
		var bda: Dictionary = _pending_bda[i]
		bda["time_remaining"] -= delta

		if bda["time_remaining"] <= 0.0:
			emit_signal(
				"battle_damage_assessment",
				bda["observer_id"],
				bda["target_pos"],
				bda["description"]
			)
			_pending_bda.remove_at(i)


## Calculate when a specific round should be fired
func _get_round_shot_time(mission: FireMission, round_index: int) -> float:
	var time := mission.shot_delay

	# Add intervals for all previous rounds
	for i in range(round_index):
		if i < mission.round_intervals.size():
			time += mission.round_intervals[i]

	return time


## Process mission completion and generate BDA
func _process_impact(mission: FireMission) -> void:
	# Note: Individual round impact signals are emitted in tick()
	# This function handles mission completion and BDA only

	# Generate BDA from nearby friendly observers
	_generate_bda(mission)


## Generate battle damage assessment from observer units
func _generate_bda(mission: FireMission) -> void:
	# Find friendly units near the impact point that can observe
	# Uses distance-based checks (artillery impacts are highly visible)
	for unit_id in _units.keys():
		var su: ScenarioUnit = _units[unit_id]
		if not su:
			continue

		# Skip the firing unit
		if unit_id == mission.unit_id:
			continue

		var pos: Vector2 = _positions.get(unit_id, Vector2.INF)
		if pos == Vector2.INF:
			continue

		# Check if within spotting range (artillery impacts are visible at distance)
		var distance: float = pos.distance_to(mission.target_pos)
		if distance > su.unit.spot_m:
			continue

		# Generate BDA from first observer in range with random delay
		var description := _generate_bda_description(mission)
		var bda_delay: float = _rng.randf_range(bda_delay_min, bda_delay_max)

		_pending_bda.append(
			{
				"observer_id": unit_id,
				"target_pos": mission.target_pos,
				"description": description,
				"time_remaining": bda_delay
			}
		)

		LogService.debug(
			"Scheduled BDA from %s in %.1fs" % [unit_id, bda_delay], "ArtilleryController"
		)

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
func _is_artillery_unit(su: ScenarioUnit) -> bool:
	if not su.unit.equipment or not su.unit.equipment.has("weapons"):
		return false

	var weapons: Dictionary = su.unit.equipment.get("weapons", {})
	for weapon_name in weapons.keys():
		var weapon_data: Dictionary = weapons[weapon_name]
		var ammo_type_index: int = int(weapon_data.get("ammo", -1))

		# Check if ammo type is mortar or artillery (indices 6-11)
		if ammo_type_index >= 6 and ammo_type_index <= 11:
			return true

	return false
