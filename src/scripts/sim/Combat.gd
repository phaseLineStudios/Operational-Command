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

##imported units manually for testing purposes
var imported_attacker: UnitData = ContentDB.get_unit("infantry_plt_1")
var imported_defender: UnitData = ContentDB.get_unit("infantry_plt_2")

var abort_condition = false
var called_retreat = false

##for testing
func _ready() -> void:
	notify_health.connect(print_unit_status) 
	combat_loop(imported_attacker, imported_defender)
	
	## ammo initialization
	if combat_adapter_path != NodePath(""):
		_adapter = get_node(combat_adapter_path) as CombatAdapter
	if _adapter == null:
		_adapter = get_tree().get_first_node_in_group("CombatAdapter") as CombatAdapter

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
	
	# consume ammo before calculating effects
	if _adapter and not _adapter.request_fire(attacker.id, "small_arms", 5):
		LogService.info("%s cannot fire: out of ammo" % attacker.id, "Combat")
		return
	
	if attacker_final_attackpower - defender_final_defensepower > 0:
		defender.strength = defender.strength - floor((attacker_final_attackpower 
				- defender_final_defensepower) * 0.1 / defender.strength)
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
## Returns:
## - `true`  → firing is allowed and (if the adapter is present) ammo was consumed.
## - `false` → firing is blocked due to empty ammo.
##
## Parameters:
## - `attacker`   : UnitData that is attempting to fire (must be registered in AmmoSystem).
## - `ammo_type`  : String key into `UnitData.state_ammunition` (e.g., "small_arms").
## - `rounds`     : Number of rounds to attempt to spend for this shot/burst.
##
## Behavior:
## - If `_adapter` is `null`, the check **fails open** and returns `true` so tests don’t break.
## - Otherwise delegates to `CombatAdapter.request_fire(...)`, which:
##     * blocks and emits `fire_blocked_empty` when empty,
##     * consumes rounds on success (calling into `AmmoSystem.consume`),
##     * causes `AmmoSystem` to emit `ammo_low` / `ammo_critical` / `ammo_empty` as thresholds are crossed.
##
## Side effects:
## - On success, `attacker.state_ammunition[ammo_type]` is reduced.
## - On empty, a bound `RadioFeedback` will typically log “Winchester”.
func _gate_and_consume(attacker: UnitData, ammo_type: String, rounds: int) -> bool:
	if _adapter == null:
		return true
	return _adapter.request_fire(attacker.id, ammo_type, rounds)
