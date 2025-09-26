extends Node
class_name CombatController
## Combat resolution for direct/indirect engagements.
##
## Applies firepower, defense, morale, terrain, elevation, surprise, and posture
## to produce losses, suppression, retreats, or destruction.

##for processing of possible combat outcomes
signal notify_health
signal unit_destroyed
signal unit_retreated
signal unit_surrendered

## Current Scenario reference
@export var scenario: ScenarioData
## Terrain renderer reference
@export var terrain_renderer: TerrainRender
## TerrainEffectConfig reference
@export var terrain_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

@export_group("Debug")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "enable debug") var debug_enabled: bool = false

var attacker_su: ScenarioUnit
var defender_su: ScenarioUnit

var abort_condition = false
var called_retreat = false

##for testing
func _ready() -> void:
	notify_health.connect(print_unit_status)

##Loop triggered every turn to simulate unit behavior in combat
func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	var unit_switch: ScenarioUnit
	
	notify_health.emit(attacker, defender)
	
	while not abort_condition :
		calculate_damage(attacker, defender)
		notify_health.emit(attacker, defender)
		check_abort_condition(attacker.unit, defender.unit)
		await get_tree().create_timer(5.0, true, false, false).timeout
		unit_switch = attacker
		attacker = defender
		defender = unit_switch

## Prototype of combat damage calculation, only using stats 
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if attacker == null or defender == null or attacker.unit == null or defender.unit == null:
		return
	var base_attack: float = attacker.unit.strength * attacker.unit.morale * attacker.unit.attack
	var base_defense: float = defender.unit.strength * defender.unit.morale * defender.unit.defense

	var env := {
		"renderer": terrain_renderer,
		"terrain": (terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null),
		"scenario": scenario,
		"config": (terrain_config if terrain_config != null else TerrainEffectsConfig.new()),
		"attacker_moving": attacker.move_state() == ScenarioUnit.MoveState.moving
	}

	var factors := TerrainEffects.compute_terrain_factors(attacker, defender, env)
	if factors.blocked:
		if attacker.unit.morale > 0.1: attacker.unit.morale = max(0.0, attacker.unit.morale - 0.01)
		return

	var attackpower := base_attack * float(factors.accuracy_mul) * float(factors.damage_mul)
	var defensepower := base_defense

	if attackpower - defensepower > 0.0:
		var denom: float = max(defender.unit.strength, 1.0)
		var loss: float = floor((attackpower - defensepower) * 0.1 / denom)
		defender.unit.strength -= max(loss, 1)
		if defender.unit.morale > 0.0:
			defender.unit.morale = max(0.0, defender.unit.morale - 0.05)
	else:
		defender.unit.strength -= 1
		if attacker.unit.morale < 1.0:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.05)

## Check the various conditions for if the combat is finished
func check_abort_condition(attacker: UnitData, defender: UnitData) -> void:
	## insert how destroyed units should be handled here and emit signal
	if defender.strength <= 0: 
		print(defender.id + " is destroyed")
		if attacker.morale <= 0.8: attacker.morale += 0.2
		unit_destroyed.emit()
		abort_condition = true
		return
		
	## insert how surrendering defenders should be handled here and emit signal
	elif defender.morale <= 0.2:
		print(defender.id + " is surrendering")
		unit_surrendered.emit()
		abort_condition = true
		return
		
	## insert how retreating units should be handled here and emit signal
	if called_retreat:
		print(defender.id + " is retreating")
		unit_retreated.emit()
		abort_condition = true

##check unit mid combat status for testing of combat status
func print_unit_status(attacker: UnitData, defender: UnitData) -> void:
	print(attacker.id)
	print(attacker.morale)
	print(attacker.strength)
	print(defender.id)
	print(defender.morale)
	print(defender.strength)
