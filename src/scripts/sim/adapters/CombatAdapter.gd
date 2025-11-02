class_name CombatAdapter
extends Node
## Small adapter that gates firing on ammo and consumes on success.
## Adds helpers to compute LOW/CRITICAL penalties (placeholders) without hard-coding
## this into AmmoSystem or combat resolution.

## Emitted when a unit attempts to fire but is out of the requested ammo type.
signal fire_blocked_empty(unit_id: String, ammo_type: String)

## NodePath to an AmmoSystem node in the scene.
@export var ammo_system_path: NodePath

var _ammo: AmmoSystem  ## Cached AmmoSystem reference


## Resolve the AmmoSystem reference when the node enters the tree.
func _ready() -> void:
	if ammo_system_path != NodePath(""):
		_ammo = get_node(ammo_system_path) as AmmoSystem
	add_to_group("CombatAdapter")


## Request to fire: returns true if ammo was consumed; false if blocked.
## Fails open (true) when there is no ammo system or unit is unknown.
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool:
	if _ammo == null:
		return true
	var u := _ammo.get_unit(unit_id)
	if u == null:
		return true
	if not u.state_ammunition.has(ammo_type):
		return true
	if _ammo.is_empty(u, ammo_type):
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
	var u := _ammo.get_unit(unit_id)
	if u == null or not u.state_ammunition.has(ammo_type):
		return res

	var cur: int = int(u.state_ammunition.get(ammo_type, 0))
	var cap: int = int(u.ammunition.get(ammo_type, 0))
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

	if ratio <= u.ammunition_critical_threshold:
		res.state = "critical"
		res.attack_power_mult = 0.5
		res.attack_cycle_mult = 1.5
		res.suppression_mult = 0.0
		res.morale_delta = -20
		res.ai_recommendation = "defensive"
	elif ratio <= u.ammunition_low_threshold:
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
	var allow := request_fire(unit_id, ammo_type, rounds)
	return {
		"allow": allow,
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
	pass
