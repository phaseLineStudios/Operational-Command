class_name CombatController
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
## Emitted whenever a debug snapshot is produced
signal debug_updated(data: Dictionary)

## Current Scenario reference
@export var scenario: ScenarioData
## Terrain renderer reference
@export var terrain_renderer: TerrainRender
## TerrainEffectConfig reference
@export
var terrain_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

@export_group("Debug")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Debug") var debug_enabled := false
## Debug sample rate (Hz) while scene runs
@export_range(0.5, 30.0, 0.5) var debug_poll_hz := 4.0
## Optional Control that implements `update_debug(data: Dictionary)`
@export var debug_overlay: Control
## Also print compact line to console
@export var debug_log_console := false

## Ammo
@export var combat_adapter_path: NodePath

##imported units manually for testing purposes
var imported_attacker: UnitData = ContentDB.get_unit("infantry_plt_1")
var imported_defender: UnitData = ContentDB.get_unit("infantry_plt_2")
var attacker_su: ScenarioUnit
var defender_su: ScenarioUnit

var abort_condition := false
var called_retreat := false

var _adapter: CombatAdapter
## Per-unit ROF cooldown (seconds since epoch when the next shot is allowed)
var _rof_cooldown: Dictionary = {}  # uid -> float(next_time_allowed_s)

var _cur_att: ScenarioUnit
var _cur_def: ScenarioUnit
var _debug_timer: Timer


## Init
func _ready() -> void:
	# Ammo adapter wiring
	if combat_adapter_path != NodePath(""):
		_adapter = get_node(combat_adapter_path) as CombatAdapter
	if _adapter == null:
		_adapter = get_tree().get_first_node_in_group("CombatAdapter") as CombatAdapter

	# Build ScenarioUnit wrappers for the imported UnitData (test harness)
	attacker_su = _make_su(imported_attacker, "ALPHA", Vector2(0, 0))
	defender_su = _make_su(imported_defender, "BRAVO", Vector2(300, 0))

	notify_health.connect(print_unit_status)

	# Start loop with ScenarioUnits
	combat_loop(attacker_su, defender_su)

	_debug_timer = Timer.new()
	_debug_timer.one_shot = false
	add_child(_debug_timer)
	_debug_timer.timeout.connect(
		func():
			if debug_enabled and _cur_att != null and _cur_def != null:
				_emit_debug_snapshot(_cur_att, _cur_def, false)
	)
	_set_debug_rate()


## Minimal factory for a ScenarioUnit used by this controller (test harness)
func _make_su(u: UnitData, cs: String, pos: Variant) -> ScenarioUnit:
	var su := ScenarioUnit.new()
	su.unit = u
	su.callsign = cs

	# Accept Vector2 or Vector3; convert 3D ground coords (x,z) -> 2D
	var p2: Vector2
	if pos is Vector2:
		p2 = pos
	elif pos is Vector3:
		p2 = Vector2((pos as Vector3).x, (pos as Vector3).z)
	else:
		p2 = Vector2.ZERO

	su.position_m = p2
	return su


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


## Combat damage calculation with terrain/environment multipliers + ammo
## gating/penalties + ROF cooldown
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if attacker == null or defender == null or attacker.unit == null or defender.unit == null:
		return

	# --- range & terrain/spotting gates ---
	var dist := attacker.position_m.distance_to(defender.position_m)
	if dist > attacker.unit.range_m:
		return

	var env := {
		"renderer": terrain_renderer,
		"terrain":
		terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null,
		"scenario": scenario,
		"config": terrain_config if terrain_config != null else TerrainEffectsConfig.new(),
		"attacker_moving": attacker.move_state() == ScenarioUnit.MoveState.MOVING
	}

	var f := TerrainEffects.compute_terrain_factors(attacker, defender, env)
	if dist > attacker.unit.spot_m * float(f.get("spotting_mul", 1.0)):
		return

	var min_acc: float = terrain_config.min_accuracy
	var acc_mul: float = float(f.get("accuracy_mul", 1.0))
	if bool(f.get("blocked", false)) or acc_mul < min_acc:
		if attacker.unit.morale > 0.1:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.01)
		return

	# --- ROF cooldown (per attacking unit) ---
	var uid := attacker.unit.id
	var now := Time.get_ticks_msec() / 1000.0
	var next_ok := float(_rof_cooldown.get(uid, 0.0))
	if now < next_ok:
		return

	# --- ammo gate + penalties ---
	# returns {allow, attack_power_mult, attack_cycle_mult, suppression_mult, ...}
	var fire := _gate_and_consume(attacker.unit, "small_arms", 5)
	if not bool(fire.get("allow", true)):
		LogService.info("%s cannot fire: out of ammo" % attacker.unit.id, "Combat")
		return

	# --- base strengths ---
	var atk_str: float = max(0.0, attacker.unit.state_strength)
	var def_str: float = max(0.0, defender.unit.state_strength)
	var base_attack: float = atk_str * attacker.unit.morale * attacker.unit.attack
	var base_defense: float = def_str * defender.unit.morale * defender.unit.defense

	# --- apply terrain multipliers ---
	var dmg_mul: float = float(f.get("damage_mul", 1.0))
	var attackpower: float = base_attack * acc_mul * dmg_mul
	var defensepower: float = base_defense

	# --- apply ammo penalties ---
	attackpower *= float(fire.get("attack_power_mult", 1.0))

	# --- apply ROF penalty as delay until next allowed shot ---
	var cycle_mult := float(fire.get("attack_cycle_mult", 1.0))
	var base_cycle := 1.0  # seconds between shots (tune to taste)
	_rof_cooldown[uid] = now + base_cycle * cycle_mult

	# TODO (if you model suppression):
	# var sup_mult := float(fire.get("suppression_mult", 1.0))
	# _apply_suppression(attacker, defender, sup_mult)

	# --- outcome ---
	if attackpower - defensepower > 0.0:
		var denom: float = max(def_str, 1.0)
		var raw_loss: int = int(floor((attackpower - defensepower) * 0.1 / denom))
		var applied := _apply_casualties(defender.unit, max(raw_loss, 1))
		if defender.unit.morale > 0.0 and applied > 0:
			defender.unit.morale = max(0.0, defender.unit.morale - 0.05)
	else:
		var applied2 := _apply_casualties(defender.unit, 1)
		if attacker.unit.morale > 0.0 and applied2 == 0:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.02)


## Check the various conditions for if the combat is finished
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if defender == null or defender.unit == null or attacker == null or attacker.unit == null:
		return

	if defender.unit.state_strength <= 0.5:
		LogService.info(defender.unit.id + " is [b]destroyed[/b]", "Combat.gd:62")
		if attacker.unit.morale <= 0.8:
			attacker._morale_sys.apply_morale_delta(0.2, "enemy surrendered")
			attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_destroyed.emit()
		abort_condition = true
		return
	elif defender.unit.morale <= 0.2:
		LogService.info(defender.unit.id + " is [b]surrendering[/b]", "Combat.gd:71")
		defender._morale_sys.set_morale(0.0, "surrendered")
		attacker._morale_sys.apply_morale_delta(0.2, "enemy surrendered")
		attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_surrendered.emit()
		abort_condition = true
		return
	if called_retreat:
		LogService.info(defender.unit.id + " is [b]retreating[/b]", "Combat.gd:78")
		attacker._morale_sys.apply_morale_delta(0.1, "enemy retreating")
		attacker.attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_retreated.emit()
		abort_condition = true


##check unit mid combat status for testing of combat status
func print_unit_status(attacker: UnitData, defender: UnitData) -> void:
	LogService.info(
		"[b]Attacker(%s)[/b]\n\t%s\n\t%s" % [attacker.id, attacker.morale, attacker.strength],
		"Combat.gd:85"
	)
	LogService.info(
		"[b]Defender(%s)[/b]\n\t%s\n\t%s" % [defender.id, defender.morale, defender.strength],
		"Combat.gd:86"
	)
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
		"state": "normal" if ok else "empty",
		"attack_power_mult": 1.0,
		"attack_cycle_mult": 1.0,
		"suppression_mult": 1.0,
		"morale_delta": 0,
		"ai_recommendation": "normal",
	}


## Apply casualties to runtime state. Returns actual KIA + WIA applied
func _apply_casualties(u: UnitData, raw_losses: int) -> int:
	if u == null or raw_losses <= 0:
		return 0
	var before := int(round(u.state_strength))
	var loss: int = clamp(raw_losses, 0, before)
	u.state_strength = float(before - loss)

	var wia_ratio := 0.6
	u.state_injured = max(0.0, u.state_injured + float(round(loss * wia_ratio)))

	var coh_per_cas := 0.01
	u.cohesion = clamp(u.cohesion - float(loss) * coh_per_cas, 0.0, 1.0)

	var eqp_per_cas := 0.01
	u.state_equipment = max(0.0, u.state_equipment - float(loss) * eqp_per_cas)
	return loss


## Debug - build and emit a snapshot (for overlays/logging)
func _emit_debug_snapshot(
	attacker: ScenarioUnit, defender: ScenarioUnit, at_resolution: bool
) -> void:
	var cfg := terrain_config if terrain_config != null else TerrainEffectsConfig.new()
	var env := {
		"renderer": terrain_renderer,
		"terrain":
		terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null,
		"scenario": scenario,
		"config": cfg,
		"attacker_moving": attacker.move_state() == ScenarioUnit.MoveState.MOVING,
		"debug": true
	}
	var f := TerrainEffects.compute_terrain_factors(attacker, defender, env)

	var atk_str: float = max(
		0.0,
		(
			attacker.unit.state_strength
			if attacker.unit.state_strength > 0.0
			else float(attacker.unit.strength)
		)
	)
	var def_str: float = max(
		0.0,
		(
			defender.unit.state_strength
			if defender.unit.state_strength > 0.0
			else float(defender.unit.strength)
		)
	)

	var base_attack := atk_str * attacker.unit.morale * attacker.unit.attack
	var base_defense := def_str * defender.unit.morale * defender.unit.defense
	var attackpower := (
		base_attack * float(f.get("accuracy_mul", 1.0)) * float(f.get("damage_mul", 1.0))
	)
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
		"attacker":
		{
			"id": attacker.unit.id,
			"cs": attacker.callsign,
			"pos_m": attacker.position_m,
			"morale": attacker.unit.morale,
			"strength": atk_str,
			"cohesion": attacker.unit.cohesion,
			"equip": attacker.unit.state_equipment,
			"moving": bool(env.get("attacker_moving", false))
		},
		"defender":
		{
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
		print(
			(
				"""[COMBAT] r=%.0fm LOS=%s acc=%.2f dmg=%.2f | h=%.1f cover=%.2f \
				conceal=%.2f atten=%.2f wx=%.2f | %s S%.0f/M%.2f -> %s S%.0f/M%.2f"""
				% [
					float(dbg.range_m),
					str(dbg.blocked),
					float(dbg.accuracy_mul),
					float(dbg.damage_mul),
					float(c.get("dh_m", 0.0)),
					float(c.get("cover", 0.0)),
					float(c.get("conceal", 0.0)),
					float(c.get("atten_integral", 0.0)),
					float(c.get("weather_severity", 0.0)),
					String(dbg.attacker.cs),
					float(dbg.attacker.strength),
					float(dbg.attacker.morale),
					String(dbg.defender.cs),
					float(dbg.defender.strength),
					float(dbg.defender.morale)
				]
			)
		)

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
