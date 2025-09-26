extends Node
class_name CombatController
## Combat resolution for direct/indirect engagements.
##
## Applies firepower, defense, morale, terrain, elevation, surprise, and posture
## to produce losses, suppression, retreats, or destruction.

## Current Scenario reference
@export var scenario: ScenarioData
## Terrain renderer reference
@export var terrain_renderer: TerrainRender
## TerrainEffectConfig reference
@export var terrain_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

@export_group("Debug")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Debug") var debug_enabled := true
## Debug sample rate (Hz) while scene runs
@export_range(0.5, 30.0, 0.5) var debug_poll_hz := 4.0
## Optional Control that implements `update_debug(data: Dictionary)`
@export var debug_overlay: Control
## Also print compact line to console
@export var debug_log_console := false

##for processing of possible combat outcomes
signal notify_health
signal unit_destroyed
signal unit_retreated
signal unit_surrendered
## Emitted whenever a debug snapshot is produced
signal debug_updated(data: Dictionary)

var attacker_su: ScenarioUnit
var defender_su: ScenarioUnit

var abort_condition := false
var called_retreat := false

var _cur_att: ScenarioUnit
var _cur_def: ScenarioUnit
var _debug_timer: Timer

## Init
func _ready() -> void:
	_debug_timer = Timer.new()
	_debug_timer.one_shot = false
	add_child(_debug_timer)
	_debug_timer.timeout.connect(func ():
		if debug_enabled and _cur_att != null and _cur_def != null:
			_emit_debug_snapshot(_cur_att, _cur_def, false)
	)
	_set_debug_rate()

##Loop triggered every turn to simulate unit behavior in combat
func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	var unit_switch: ScenarioUnit
	_cur_att = attacker
	_cur_def = defender
	notify_health.emit(attacker.unit, defender.unit)

	while not abort_condition:
		calculate_damage(attacker, defender)
		notify_health.emit(attacker.unit, defender.unit)
		check_abort_condition(attacker, defender)

		if debug_enabled:
			_emit_debug_snapshot(attacker, defender, true)

		await get_tree().create_timer(5.0, true, false, false).timeout
		unit_switch = attacker
		attacker = defender
		defender = unit_switch
		_cur_att = attacker
		_cur_def = defender

## Combat damage calculation with terrain/environment multipliers
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if attacker == null or defender == null or attacker.unit == null or defender.unit == null:
		return

	var atk_str: float = max(0.0, attacker.unit.state_strength)
	var def_str: float = max(0.0, defender.unit.state_strength)

	var base_attack: float = atk_str * attacker.unit.morale * attacker.unit.attack
	var base_defense: float = def_str * defender.unit.morale * defender.unit.defense

	var env := {
		"renderer": terrain_renderer,
		"terrain": (terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null),
		"scenario": scenario,
		"config": (terrain_config if terrain_config != null else TerrainEffectsConfig.new()),
		"attacker_moving": (attacker.move_state() == ScenarioUnit.MoveState.moving)
	}

	var f := TerrainEffects.compute_terrain_factors(attacker, defender, env)
	if f.blocked:
		if attacker.unit.morale > 0.1:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.01)
		return

	var attackpower := base_attack * float(f.accuracy_mul) * float(f.damage_mul)
	var defensepower := base_defense

	if attackpower - defensepower > 0.0:
		var denom: float = max(def_str, 1.0)
		var raw_loss: int = int(floor((attackpower - defensepower) * 0.1 / denom))
		var applied := _apply_casualties(defender.unit, max(raw_loss, 1))
		if defender.unit.morale > 0.0 and applied > 0:
			defender.unit.morale = max(0.0, defender.unit.morale - 0.05)
	else:
		var applied := _apply_casualties(defender.unit, 1)
		if attacker.unit.morale > 0.0 and applied == 0:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.02)

## Check the various conditions for if the combat is finished
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if defender == null or defender.unit == null or attacker == null or attacker.unit == null:
		return

	if defender.unit.state_strength <= 0.5:
		print(defender.callsign + " is destroyed")
		if attacker.unit.morale <= 0.8:
			attacker.unit.morale += 0.2
		unit_destroyed.emit()
		abort_condition = true
		return
	elif defender.unit.morale <= 0.2:
		print(defender.callsign + " is surrendering")
		unit_surrendered.emit()
		abort_condition = true
		return
	if called_retreat:
		print(defender.callsign + " is retreating")
		unit_retreated.emit()
		abort_condition = true

## Apply casualties to runtime state. Returns actual KIA + WIA applied
func _apply_casualties(u: UnitData, raw_losses: int) -> int:
	if u == null or raw_losses <= 0: return 0
	var before := int(round(u.state_strength))
	var loss: int = clamp(raw_losses, 0, before)
	u.state_strength = float(before - loss)

	var WIA_RATIO := 0.6
	u.state_injured = max(0.0, u.state_injured + float(round(loss * WIA_RATIO)))

	var COH_PER_CAS := 0.01
	u.cohesion = clamp(u.cohesion - float(loss) * COH_PER_CAS, 0.0, 1.0)

	var EQP_PER_CAS := 0.01
	u.state_equipment = max(0.0, u.state_equipment - float(loss) * EQP_PER_CAS)
	return loss

## Debug - build and emit a snapshot (for overlays/logging)
func _emit_debug_snapshot(attacker: ScenarioUnit, defender: ScenarioUnit, at_resolution: bool) -> void:
	var cfg := (terrain_config if terrain_config != null else TerrainEffectsConfig.new())
	var env := {
		"renderer": terrain_renderer,
		"terrain": (terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null),
		"scenario": scenario,
		"config": cfg,
		"attacker_moving": (attacker.move_state() == ScenarioUnit.MoveState.moving),
		"debug": true
	}
	var f := TerrainEffects.compute_terrain_factors(attacker, defender, env)

	var atk_str: float = max(0.0, attacker.unit.state_strength if attacker.unit.state_strength > 0.0 else attacker.unit.strength)
	var def_str: float = max(0.0, defender.unit.state_strength if defender.unit.state_strength > 0.0 else defender.unit.strength)

	var base_attack := atk_str * attacker.unit.morale * attacker.unit.attack
	var base_defense := def_str * defender.unit.morale * defender.unit.defense
	var attackpower := base_attack * float(f.get("accuracy_mul", 1.0)) * float(f.get("damage_mul", 1.0))
	var defensepower := base_defense

	var dbg := {
		"time_s": float(Time.get_ticks_msec()) * 0.001,
		"at_resolution": at_resolution,
		"range_m": float(f.get("range_m", 0.0)),
		"blocked": bool(f.get("blocked", false)),
		"accuracy_mul": float(f.get("accuracy_mul", 1.0)),
		"damage_mul": float(f.get("damage_mul", 1.0)),
		"spotting_mul": float(f.get("spotting_mul", 1.0)),
		"base_attack": base_attack,
		"base_defense": base_defense,
		"attackpower": attackpower,
		"defensepower": defensepower,
		"attacker": {
			"id": attacker.unit.id, 
			"cs": attacker.callsign, 
			"pos_m": attacker.position_m,
			"morale": attacker.unit.morale, 
			"strength": atk_str, 
			"cohesion": attacker.unit.cohesion,
			"equip": attacker.unit.state_equipment, 
			"moving": env.attacker_moving
		},
		"defender": {
			"id": defender.unit.id, 
			"cs": defender.callsign, 
			"pos_m": defender.position_m,
			"morale": defender.unit.morale, 
			"strength": def_str, 
			"cohesion": defender.unit.cohesion,
			"equip": defender.unit.state_equipment
		},
		"components": f.get("debug", {})
	}

	if debug_log_console:
		var c: Variant = dbg.components
		print("[COMBAT] r=%.0fm LOS=%s acc=%.2f dmg=%.2f | dh=%.1f cover=%.2f conceal=%.2f atten=%.2f wx=%.2f | %s S%.0f/M%.2f -> %s S%.0f/M%.2f" % [
			float(dbg.range_m),
			str(dbg.blocked),
			float(dbg.accuracy_mul), float(dbg.damage_mul),
			float(c.get("dh_m", 0.0)),
			float(c.get("cover", 0.0)),
			float(c.get("conceal", 0.0)),
			float(c.get("atten_integral", 0.0)),
			float(c.get("weather_severity", 0.0)),
			String(dbg.attacker.cs), float(dbg.attacker.strength), float(dbg.attacker.morale),
			String(dbg.defender.cs), float(dbg.defender.strength), float(dbg.defender.morale)
		])

	emit_signal("debug_updated", dbg)
	if debug_overlay and debug_overlay.has_method("update_debug"):
		debug_overlay.update_debug(dbg)

## Adjust debug timer
func _set_debug_rate() -> void:
	if _debug_timer == null:
		return
	_debug_timer.wait_time = 1.0 / max(debug_poll_hz, 0.5)
	if debug_enabled:
		_debug_timer.start()
	else:
		_debug_timer.stop()

## Toggle debug at runtime
func set_debug_enabled(v: bool) -> void:
	debug_enabled = v
	_set_debug_rate()
