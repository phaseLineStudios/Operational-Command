extends RefCounted
class_name MoraleSystem
# adjust on losses and wins [X]
# allied win [X]
# weather [X]
# long idle (on frontline?) [X]
# safe rest []

signal morale_changed(unit_id, prev, cur, source)
signal morale_state_changed(unit_id, prev, cur)

enum MoraleState { STEADY, SHAKEN, BROKEN }

var unit_id: String            
var morale: float = 0.6
var morale_state: int = MoraleState.STEADY
var owner: ScenarioUnit
var scenario: ScenarioData = Game.current_scenario

func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void:
	unit_id = u_id
	morale_state = get_morale_state(morale)
	owner = u_owner

func get_morale() -> float:
	return morale

## Set morale directly (e.g. init or full reset)
#source is reason for change
func set_morale(value: float, source: String = "direct") -> void:
	var prev_val := morale
	var prev_state := morale_state

	morale = clamp(value, 0.0, 1.0)
	morale_state = get_morale_state(morale)

	if prev_val != morale:
		emit_signal("morale_changed", unit_id, prev_val, morale, source)
	if prev_state != morale_state:
		emit_signal("morale_state_changed", unit_id, prev_state, morale_state)

#source is reason for change
func apply_morale_delta(delta: float, source: String = "delta") -> void:
	if delta != 0:
		set_morale(morale + delta, source)

func get_morale_state(value: float = morale) -> int:
	if value >= 0.6: return MoraleState.STEADY
	elif value >= 0.3: return MoraleState.SHAKEN
	else: return MoraleState.BROKEN

#sjekke om i safe område
func tick(dt) -> void:
	#idle
	if owner.move_state() == ScenarioUnit.MoveState.idle:
		apply_morale_delta(-0.001 * dt, "idle_decay")

	# no safe zones implemented
	#if is_in_safe_zone():
		#apply_morale_delta(+0.02 * dt, "safe_zone")

	#weather
	if scenario.rain > 10.0:
		apply_morale_delta(-0.002 * dt, "heavy_rain")
	if scenario.fog_m > 5000.0:
		apply_morale_delta(-0.001 * dt, "dense_fog")
	if scenario.wind_speed_m > 15.0:
		apply_morale_delta(-0.001 * dt, "dense_fog")

#funksjon fra combat
# funksjon fra unit til units i nærheten
func nearby_ally_morale_change(amount: float, source: String = "nearby victory") -> void:
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

func morale_effectiveness_mul() -> float:
	var state = get_morale_state()
	if state == 2:
		return 0.9
	elif state == 3:
		return 0.7
	else:
		return 1

#gains morale if no enemies nearby
func safe_rest() -> void:
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
	if safe == true && owner.move_state() == ScenarioUnit.MoveState.idle:
		if morale + 0.3 > 0.6:
			set_morale(0.6,"safe rest")
		else:
			apply_morale_delta(0.3,"safe rest")
