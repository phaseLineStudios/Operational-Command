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

##imported units manually for testing purposes
var imported_attacker: UnitData = ContentDB.get_unit("infantry_plt_1")
var imported_defender: UnitData = ContentDB.get_unit("infantry_plt_2")

var abort_condition = false
var called_retreat = false

##for testing
func _ready() -> void:
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
	
	## insert how destroyed units should be handled here and emit signal
	if defender.strength <= 0: 
		print(defender.id + " is destroyed")
		if attacker.morale <= 0.8:
			attacker.morale += 0.2
		unit_destroyed.emit()
		abort_condition = 1
		return
		
	## insert how surrendering defenders should be handled here and emit signal
	elif defender.morale <= 0.2:
		print(defender.id + " is surrendering")
		unit_surrendered.emit()
		abort_condition = 1
		return
		
	## insert how retreating units should be handled here and emit signal
	if called_retreat:
		print(defender.id + " is retreating")
		unit_retreated.emit()
		abort_condition = 1
		return

##check unit mid combat status for testing of combat status
func print_unit_status(attacker: UnitData, defender: UnitData) -> void:
	print(attacker.id)
	print(attacker.morale)
	print(attacker.strength)
	print(defender.id)
	print(defender.morale)
	print(defender.strength)
	return
