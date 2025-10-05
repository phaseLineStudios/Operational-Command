extends Node
## Combat resolution for direct/indirect engagements.
##
## Applies firepower, defense, morale, terrain, elevation, surprise, and posture
## to produce losses, suppression, retreats, or destruction.

##for processing of possible combat outcomes
signal notify_health
signal unit_destroyed
signal unit_retreated
signal unit_surrendered

## Ammo 
@export var combat_adapter_path: NodePath
var _adapter: CombatAdapter

## Define Cooldown, mainly used for applying penalties for low ammo
var _rof_cooldown: Dictionary = {}  # uid -> next_time_allowed (float)

##imported units manually for testing purposes
var imported_attacker: UnitData = ContentDB.get_unit("infantry_plt_1")
var imported_defender: UnitData = ContentDB.get_unit("infantry_plt_2")

var abort_condition = false
var called_retreat = false

##for testing
func _ready() -> void:
	## ammo initialization (moved before starting the loop)
	if combat_adapter_path != NodePath(""):
		_adapter = get_node(combat_adapter_path) as CombatAdapter
	if _adapter == null:
		_adapter = get_tree().get_first_node_in_group("CombatAdapter") as CombatAdapter

	notify_health.connect(print_unit_status)
	combat_loop(imported_attacker, imported_defender)

##Loop triggered every turn to simulate unit behavior in combat
func combat_loop(attacker: UnitData, defender: UnitData) -> void:
	var unit_switch
	
	notify_health.emit(attacker, defender)
	
	while !abort_condition :
		calculate_damage(attacker, defender)
		notify_health.emit(attacker, defender)
		check_abort_condition(attacker, defender)
		await get_tree().create_timer(5.0, true, false, false).timeout
		unit_switch = attacker
		attacker = defender
		defender = unit_switch
		

## Prototype of combat damage calculation, only using stats 
func calculate_damage(attacker: UnitData, defender: UnitData) -> void:
	var attacker_final_attackpower: float = attacker.strength * attacker.morale * attacker.attack
	var defender_final_defensepower: float = defender.strength * defender.morale * defender.defense

	# --- ROF cooldown (per attacker) ---
	var now := Time.get_ticks_msec() / 1000.0
	var next_ok := float(_rof_cooldown.get(attacker.id, 0.0))
	if now < next_ok:
		return

	# --- ammo gate + penalties ---
	var fire := _gate_and_consume(attacker, "small_arms", 5)  # Dictionary
	if not bool(fire.get("allow", true)):
		LogService.info("%s cannot fire: out of ammo" % attacker.id, "Combat")
		return

	# Apply power penalty (low/critical)
	attacker_final_attackpower *= float(fire.get("attack_power_mult", 1.0))

	# Apply ROF penalty as a delay until next allowed shot
	var cycle_mult := float(fire.get("attack_cycle_mult", 1.0))
	var base_cycle := 1.0  # seconds between shots (tune to taste)
	_rof_cooldown[attacker.id] = now + base_cycle * cycle_mult

	# TODO (if you model suppression):
	# var sup_mult := float(fire.get("suppression_mult", 1.0))
	# _apply_suppression(attacker, defender, sup_mult)

	# --- simple outcome (unchanged) ---
	if attacker_final_attackpower - defender_final_defensepower > 0:
		defender.strength = defender.strength - floor((attacker_final_attackpower 
				- defender_final_defensepower) * 0.1 / max(1, defender.strength))
		if defender.morale > 0:
			defender.morale -= 0.05
	else:
		defender.strength -= 1
		if attacker.morale < 1:
			attacker.morale -= 0.05
	return


## Check the various conditions for if the combat is finished
func check_abort_condition(attacker: UnitData, defender: UnitData) -> void:
	if defender.strength <= 0: 
		LogService.info(defender.id + " is [b]destroyed[/b]", "Combat.gd:62")
		if attacker.morale <= 0.8:
			attacker.morale += 0.2
		unit_destroyed.emit()
		abort_condition = 1
		return

	elif defender.morale <= 0.2:
		LogService.info(defender.id + " is [b]surrendering[/b]", "Combat.gd:71")
		unit_surrendered.emit()
		abort_condition = 1
		return

	if called_retreat:
		LogService.info(defender.id + " is [b]retreating[/b]", "Combat.gd:78")
		unit_retreated.emit()
		abort_condition = 1
		return

##check unit mid combat status for testing of combat status
func print_unit_status(attacker: UnitData, defender: UnitData) -> void:
	LogService.info("[b]Attacker(%s)[/b]\n\t%s\n\t%s" % [attacker.id, attacker.morale, attacker.strength], "Combat.gd:85")
	LogService.info("[b]Defender(%s)[/b]\n\t%s\n\t%s" % [defender.id, defender.morale, defender.strength], "Combat.gd:86")
	return
	
	
## Gate a fire attempt by ammunition and consume rounds when allowed.
##
## Returns a Dictionary with at least:
##  { allow: bool, state: String, attack_power_mult: float,
##    attack_cycle_mult: float, suppression_mult: float, morale_delta: int,
##    ai_recommendation: String }
##
## Behavior:
## - If `_adapter` is null → allow=true with neutral multipliers (keeps tests running).
## - If `CombatAdapter.request_fire_with_penalty()` exists → use it.
## - Else fall back to `request_fire()` and map to a neutral response.
func _gate_and_consume(attacker: UnitData, ammo_type: String, rounds: int) -> Dictionary:
	if _adapter == null:
		return {
			"allow": true,
			"state": "normal",
			"attack_power_mult": 1.0,
			"attack_cycle_mult": 1.0,
			"suppression_mult": 1.0,
			"morale_delta": 0,
			"ai_recommendation": "normal",
		}

	# Preferred path (penalties + consume)
	if _adapter.has_method("request_fire_with_penalty"):
		return _adapter.request_fire_with_penalty(attacker.id, ammo_type, rounds)

	# Fallback: just block/consume via request_fire, no penalties
	var ok := _adapter.request_fire(attacker.id, ammo_type, rounds)
	return {
		"allow": ok,
		"state": ("normal" if ok else "empty"),
		"attack_power_mult": 1.0,
		"attack_cycle_mult": 1.0,
		"suppression_mult": 1.0,
		"morale_delta": 0,
		"ai_recommendation": "normal",
	}
