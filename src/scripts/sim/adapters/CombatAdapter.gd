class_name CombatAdapter
extends Node
## Small adapter that gates firing on ammo and consumes on success.
## Adds helpers to compute LOW/CRITICAL penalties (placeholders) without hard-coding
## this into AmmoSystem or combat resolution.

## Emitted when a unit attempts to fire but is out of the requested ammo type.
signal fire_blocked_empty(unit_id: String, ammo_type: String)

## Minimal ROE gate that other systems can consult or drive.
## We can expand this to hook into our targeting and firing systems.
enum ROE { HOLD_FIRE, RETURN_FIRE, OPEN_FIRE }

## How long after a hostile shot we consider "return fire" permitted.
@export var return_fire_window_sec: float = 5.0

## NodePath to an AmmoSystem node in the scene.
@export var ammo_system_path: NodePath

var _ammo: AmmoSystem  ## Cached AmmoSystem reference

var _roe: int = 2  # 0 HOLD_FIRE, 1 RETURN_FIRE, 2 OPEN_FIRE
var _shot_timer: float = 0.0
var _saw_hostile_shot: bool = false


## Resolve the AmmoSystem reference when the node enters the tree.
func _ready() -> void:
	if ammo_system_path != NodePath(""):
		_ammo = get_node(ammo_system_path) as AmmoSystem
	add_to_group("CombatAdapter")


func _process(dt: float) -> void:
	if _saw_hostile_shot:
		_shot_timer -= dt
		if _shot_timer <= 0.0:
			_saw_hostile_shot = false


## Request to fire: returns true if ammo was consumed; false if blocked.
## Fails open (true) when there is no ammo system or unit is unknown.
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool:
	if _ammo == null:
		return true
	var su := _ammo.get_unit(unit_id)
	if su == null:
		return true
	if not su.state_ammunition.has(ammo_type):
		return true
	if _ammo.is_empty(su, ammo_type):
		emit_signal("fire_blocked_empty", unit_id, ammo_type)
		return false
	return _ammo.consume(unit_id, ammo_type, max(1, rounds))


## Compute penalty multipliers given the unit and ammo_type *without* consuming.
## States:
## - "normal": no penalty
## - "low":     ≤ u.ammunition_low_threshold (and > critical)
## - "critical":≤ u.ammunition_critical_threshold (and > 0)
## - "empty":   == 0 (weapon is hard-blocked elsewhere)
##
## Returns a Dictionary:
## {
##   state: "normal"|"low"|"critical"|"empty",
##   attack_power_mult: float,  # 1.0 normal, 0.8 low, 0.5 critical
##   attack_cycle_mult: float, # 1.0 normal, 1.25 low, 1.5 critical (use to scale cycle/cooldown)
##   suppression_mult:  float, # 1.0 normal, 0.75 low, 0.0 critical (disable area fire)
##   morale_delta:      int,   # 0 normal, -10 low, -20 critical (apply in morale system if desired)
##   ai_recommendation: String # "normal"|"conserve"|"defensive"|"avoid"
## }
func get_ammo_penalty(unit_id: String, ammo_type: String) -> Dictionary:
	var res := {
		"state": "normal",
		"attack_power_mult": 1.0,
		"attack_cycle_mult": 1.0,
		"suppression_mult": 1.0,
		"morale_delta": 0,
		"ai_recommendation": "normal",
	}

	if _ammo == null:
		return res
	var su := _ammo.get_unit(unit_id)
	if su == null or not su.state_ammunition.has(ammo_type):
		return res

	var cur: int = int(su.state_ammunition.get(ammo_type, 0))
	var cap: int = int(su.unit.ammunition.get(ammo_type, 0))
	if cap <= 0:
		return res

	if cur <= 0:
		res.state = "empty"
		res.attack_power_mult = 0.0
		res.attack_cycle_mult = 2.0
		res.suppression_mult = 0.0
		res.morale_delta = -20
		res.ai_recommendation = "avoid"
		return res

	var ratio: float = float(cur) / float(cap)

	if ratio <= su.unit.ammunition_critical_threshold:
		res.state = "critical"
		res.attack_power_mult = 0.5
		res.attack_cycle_mult = 1.5
		res.suppression_mult = 0.0
		res.morale_delta = -20
		res.ai_recommendation = "defensive"
	elif ratio <= su.unit.ammunition_low_threshold:
		res.state = "low"
		res.attack_power_mult = 0.8
		res.attack_cycle_mult = 1.25
		res.suppression_mult = 0.75
		res.morale_delta = -10
		res.ai_recommendation = "conserve"

	return res


## Request to fire *and* return penalty info for the caller to apply to accuracy/ROF/etc.
## Example use in combat:
##   var r := _adapter.request_fire_with_penalty(attacker.id, "small_arms", 5)
##   if r.allow:
##       accuracy *= r.attack_power_mult
##       cycle_time *= r.attack_cycle_mult
##       suppression *= r.suppression_mult
##       # optionally apply r.morale_delta and heed r.ai_recommendation
func request_fire_with_penalty(unit_id: String, ammo_type: String, rounds: int = 1) -> Dictionary:
	var pen := get_ammo_penalty(unit_id, ammo_type)
	var allow := false
	match _roe:
		0:
			allow = false
		1:
			allow = _saw_hostile_shot
		2:
			allow = true
	if not allow:
		return {
			"allow": false,
			"state": "roe_blocked",
			"attack_power_mult": 1.0,
			"attack_cycle_mult": 1.0,
			"suppression_mult": 1.0,
			"morale_delta": 0,
			"ai_recommendation": "hold"
		}
	return {
		"allow": request_fire(unit_id, ammo_type, rounds),
		"state": pen.state,
		"attack_power_mult": pen.attack_power_mult,
		"attack_cycle_mult": pen.attack_cycle_mult,
		"suppression_mult": pen.suppression_mult,
		"morale_delta": pen.morale_delta,
		"ai_recommendation": pen.ai_recommendation,
	}


## Rules of engagement from AIAgent
## 0 = HOLD_FIRE, 1 = RETURN_FIRE, 2 = OPEN_FIRE
func set_rules_of_engagement(mode: int) -> void:
	_roe = mode


## External systems call this when the unit observes an enemy firing event.
func report_hostile_shot_observed() -> void:
	_saw_hostile_shot = true
	_shot_timer = return_fire_window_sec


## Query for fire permission based on current ROE.
func can_fire() -> bool:
	match _roe:
		ROE.HOLD_FIRE:
			return false
		ROE.RETURN_FIRE:
			return _saw_hostile_shot
		ROE.OPEN_FIRE:
			return true
	return false
