class_name MoraleSystem
extends RefCounted

##Morale system for units
##handles changes in morale and decay of morale over time

signal morale_changed(unit_id, prev, cur, source)
signal morale_state_changed(unit_id, prev, cur)

enum MoraleState { STEADY, SHAKEN, BROKEN }

var unit_id: String  ##id of unit
var morale: float = 0.6  ##pure value used to determine state
var morale_state: int = MoraleState.STEADY  ##state used for multiplier
var owner: ScenarioUnit  ##unit connected to the script
var scenario: ScenarioData  ##points to current scenario to check weather


##sets value of id variables
func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void:
	unit_id = u_id
	morale_state = get_morale_state(morale)
	owner = u_owner
	scenario = Game.current_scenario


##returns the raw moralevalue
func get_morale() -> float:
	return morale


## changes moralevalue to a new value
func set_morale(value: float, source: String = "direct") -> void:
	var prev_val := morale
	var prev_state := morale_state

	morale = clamp(value, 0.0, 1.0)
	morale_state = get_morale_state(morale)

	if prev_val != morale:
		emit_signal("morale_changed", unit_id, prev_val, morale, source)
	if prev_state != morale_state:
		emit_signal("morale_state_changed", unit_id, prev_state, morale_state)


##changes morale value
func apply_morale_delta(delta: float, source: String = "delta") -> void:
	if delta != 0:
		set_morale(morale + delta, source)


##returns moralestate based on morale value
func get_morale_state(value: float = morale) -> int:
	if value >= 0.6:
		return MoraleState.STEADY  #0
	elif value >= 0.3:
		return MoraleState.SHAKEN  #1
	else:
		return MoraleState.BROKEN  #2


##bool to see if morealstate is broken
func is_broken() -> bool:
	if get_morale_state() == MoraleState.BROKEN:
		return true
	else:
		return false


##applies overtime moralechanges
func tick(dt: float) -> void:
	if not scenario:
		return

	#idle
	if owner.move_state() == ScenarioUnit.MoveState.IDLE:
		apply_morale_delta(-0.0002 * dt, "idle_decay")
	safe_rest()
	if scenario.rain > 10.0:
		apply_morale_delta(-0.0004 * dt, "heavy_rain")
	if scenario.fog_m > 5000.0:
		apply_morale_delta(-0.0002 * dt, "dense_fog")
	if scenario.wind_speed_m > 15.0:
		apply_morale_delta(-0.0002 * dt, "high_winds")


##applies morale boost to nearby units
func nearby_ally_morale_change(amount: float = 0.0, source: String = "nearby victory") -> void:
	if not scenario or not scenario.units:
		return

	var nearby: Array = []
	var max_distance = 500

	for other in scenario.units:
		if other == owner:
			continue
		if other.affiliation != owner.affiliation:
			continue

		var dist = other.position_m.distance_to(owner.position_m)
		if dist <= max_distance:
			nearby.append(other)

	for ally in nearby:
		ally.morale_system.apply_morale_delta(amount, source)


##returns morale multiplier based on moralestate
func morale_effectiveness_mul() -> float:
	var state = get_morale_state()
	if state == MoraleState.SHAKEN:
		return 0.9
	elif state == MoraleState.BROKEN:
		return 0.7
	else:
		return 1


##gains morale if no enemies nearby
func safe_rest() -> void:
	if not scenario or not scenario.units:
		return

	var min_distance = 2000
	var safe = true

	for other in scenario.units:
		if other == owner:
			continue
		if other.affiliation == owner.affiliation:
			continue
		var dist = other.position_m.distance_to(owner.position_m)
		if dist <= min_distance:
			safe = false
	if safe == true && owner.move_state() == ScenarioUnit.MoveState.IDLE:
		if morale + 0.3 > 0.6:
			set_morale(0.6, "safe rest")
		else:
			apply_morale_delta(0.3, "safe rest")
