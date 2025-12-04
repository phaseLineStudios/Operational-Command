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
## Adapter used to gate fire and apply ammo penalties. Prefer assigning directly.
@export var combat_adapter: CombatAdapter
## TerrainEffectConfig reference
@export
var terrain_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")
## Lookup table for ammo type damage profiles.
@export
var ammo_damage_config: AmmoDamageConfig = preload("res://assets/configs/ammo_damage_config.tres")

@export_group("Debug")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Debug") var debug_enabled := false
## Debug sample rate (Hz) while scene runs
@export_range(0.5, 30.0, 0.5) var debug_poll_hz := 4.0
## Optional Control that implements `update_debug(data: Dictionary)`
@export var debug_overlay: Control
## Also print compact line to console
@export var debug_log_console := false

##imported units manually for testing purposes
var imported_attacker: UnitData = ContentDB.get_unit("infantry_plt_1")
var imported_defender: UnitData = ContentDB.get_unit("infantry_plt_2")
var attacker_su: ScenarioUnit
var defender_su: ScenarioUnit

var abort_condition := false
var called_retreat := false

## Per-unit ROF cooldown (seconds since epoch when the next shot is allowed)
var _rof_cooldown: Dictionary = {}  # uid -> float(next_time_allowed_s)

var _cur_att: ScenarioUnit
var _cur_def: ScenarioUnit
var _debug_timer: Timer


## Init
func _ready() -> void:
	# Build ScenarioUnit wrappers for the imported UnitData (test harness)
	attacker_su = _make_su(imported_attacker, "ALPHA", Vector2(0, 0))
	defender_su = _make_su(imported_defender, "BRAVO", Vector2(300, 0))

	if debug_enabled:
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
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> float:
	if attacker == null or defender == null or attacker.unit == null or defender.unit == null:
		return 0.0

	match attacker.combat_mode:
		ScenarioUnit.CombatMode.FORCED_HOLD_FIRE:
			return 0.0
		ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON:
			if not defender.has_meta("recently_attacked_" + attacker.id):
				return 0.0
		_:
			pass

	# --- range & terrain/spotting gates ---
	var dist_m := attacker.position_m.distance_to(defender.position_m)
	if not _within_engagement_envelope(attacker, dist_m):
		return 0.0

	var env := {
		"renderer": terrain_renderer,
		"terrain":
		terrain_renderer.data if terrain_renderer and "data" in terrain_renderer else null,
		"scenario": scenario,
		"config": terrain_config if terrain_config != null else TerrainEffectsConfig.new(),
		"attacker_moving": attacker.move_state() == ScenarioUnit.MoveState.MOVING
	}

	var f := TerrainEffects.compute_terrain_factors(attacker, defender, env)

	# Note: Do NOT apply spotting_mul to range here - that creates a disconnect
	# with the LOS system. If has_los() passed, the unit should be able to engage
	# (within engagement_envelope). The spotting_mul affects accuracy/damage, not range.

	var min_acc: float = terrain_config.min_accuracy
	var acc_mul: float = float(f.get("accuracy_mul", 1.0))
	if bool(f.get("blocked", false)) or acc_mul < min_acc:
		if attacker.unit.morale > 0.1:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.01)
		return 0.0

	# --- ROF cooldown (per attacking unit) ---
	var uid := attacker.unit.id
	var now := Time.get_ticks_msec() / 1000.0
	var next_ok := float(_rof_cooldown.get(uid, 0.0))
	if now < next_ok:
		return 0.0

	# --- ammo gate + penalties ---
	# returns {allow, attack_power_mult, attack_cycle_mult, suppression_mult, ...}
	var ammo_meta := _select_ammo_profile_for_attack(attacker, defender)
	var fire := _gate_and_consume(
		attacker.unit,
		attacker.id,
		ammo_meta.get("ammo_type", "SMALL_ARMS"),
		int(ammo_meta.get("rounds", 5))
	)
	if not bool(fire.get("allow", true)):
		LogService.info("%s cannot fire: out of ammo" % attacker.unit.id, "Combat")
		return 0.0

	# --- base strengths via equipment-aware helpers ---
	var dynamic_attack: float = _compute_dynamic_attack_power(attacker)
	if dynamic_attack <= 0.0:
		return 0.0
	var defensepower: float = _compute_dynamic_defense_value(defender)
	var def_str: float = max(0.0, defender.state_strength)

	# --- apply terrain multipliers ---
	var dmg_mul: float = float(f.get("damage_mul", 1.0))
	var attackpower: float = dynamic_attack * acc_mul * dmg_mul

	# --- apply ammo penalties ---
	attackpower *= float(fire.get("attack_power_mult", 1.0))

	# --- defense mitigation ---
	var mitigated_attack: float = _apply_defense_modifier_to_damage(attackpower, defensepower)

	# --- apply ROF penalty as delay until next allowed shot ---
	var cycle_mult := float(fire.get("attack_cycle_mult", 1.0))
	var base_cycle := 4.0  # seconds between shots (tune to taste)
	_rof_cooldown[uid] = now + base_cycle * cycle_mult

	# TODO (if you model suppression):
	# var sup_mult := float(fire.get("suppression_mult", 1.0))
	# _apply_suppression(attacker, defender, sup_mult)

	# --- outcome ---
	var denom: float = max(def_str, 1.0)
	var raw_loss: int = int(floor(mitigated_attack * 0.1 / denom))
	if raw_loss <= 0:
		raw_loss = 1
	var applied := _apply_casualties(defender, raw_loss)
	if defender.unit.morale > 0.0 and applied > 0:
		defender.unit.morale = max(0.0, defender.unit.morale - 0.05)
	elif attacker.unit.morale > 0.0 and applied <= 0:
		attacker.unit.morale = max(0.0, attacker.unit.morale - 0.02)

	# Mark defender as under fire (for auto-pause logic)
	if applied > 0:
		defender.mark_under_fire()

	_apply_vehicle_damage_resolution(attacker, defender, mitigated_attack)
	return raw_loss


## Check the various conditions for if the combat is finished
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if defender == null or defender.unit == null or attacker == null or attacker.unit == null:
		return

	if defender.unit.strength / defender.state_strength <= 0.5:
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
	LogService.trace(
		(
			"Attacker(%s) • morale %s • strength %s"
			% [attacker.id, attacker.morale, attacker.strength]
		),
		"Combat.gd:85"
	)
	LogService.trace(
		(
			"Defender(%s) • morale %s • strength %s"
			% [defender.id, defender.morale, defender.strength]
		),
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
## [param attacker] UnitData of the attacking unit.
## [param attacker_id] ScenarioUnit ID (with SLOT suffix if applicable).
## [param ammo_type] Ammunition type string.
## [param rounds] Number of rounds to consume.
func _gate_and_consume(
	_attacker: UnitData, attacker_id: String, ammo_type: String, rounds: int
) -> Dictionary:
	if ammo_type == "" or rounds <= 0:
		return {
			"allow": true,
			"state": "virtual",
			"attack_power_mult": 1.0,
			"attack_cycle_mult": 1.0,
			"suppression_mult": 1.0,
			"morale_delta": 0,
			"ai_recommendation": "normal",
		}

	if combat_adapter == null:
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
	if combat_adapter.has_method("request_fire_with_penalty"):
		return combat_adapter.request_fire_with_penalty(attacker_id, ammo_type, rounds)

	# Fallback: just block/consume via request_fire, no penalties
	var ok := combat_adapter.request_fire(attacker_id, ammo_type, rounds)
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
func _apply_casualties(su: ScenarioUnit, raw_losses: int) -> int:
	if su == null or su.unit == null or raw_losses <= 0:
		return 0
	var before := int(round(su.state_strength))
	var loss: int = clamp(raw_losses, 0, before)
	su.state_strength = float(before - loss)

	# Record for debrief summary (does NOT re-apply at debrief unless change policy)
	var game := get_tree().get_root().get_node_or_null("/root/Game")
	if game and game.has_node("resolution"):
		game.resolution.add_unit_losses(su.unit.id, loss)

	var wia_ratio := 0.6
	su.state_injured = max(0.0, su.state_injured + float(round(loss * wia_ratio)))

	var coh_per_cas := 0.01
	su.cohesion = clamp(su.cohesion - float(loss) * coh_per_cas, 0.0, 1.0)

	var eqp_per_cas := 0.01
	su.state_equipment = max(0.0, su.state_equipment - float(loss) * eqp_per_cas)
	return loss


## True if attacker is permitted to fire at defender at distance 'dist_m'.
## Note: LOS/spotting is already checked via LOSAdapter before combat resolution.
## This only checks if target is within weapon engagement range.
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool:
	var engage_m := attacker.unit.range_m
	if engage_m <= 0.0:
		return false
	return dist_m <= engage_m + 0.5


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
		attacker.state_strength if attacker.state_strength > 0.0 else float(attacker.unit.strength)
	)
	var def_str: float = max(
		0.0,
		defender.state_strength if defender.state_strength > 0.0 else float(defender.unit.strength)
	)

	var base_attack := _compute_dynamic_attack_power(attacker)
	var base_defense := _compute_dynamic_defense_value(defender)
	var attackpower := (
		base_attack * float(f.get("accuracy_mul", 1.0)) * float(f.get("damage_mul", 1.0))
	)
	var defensepower := base_defense
	var mitigated_power := _apply_defense_modifier_to_damage(attackpower, defensepower)

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
			"cohesion": attacker.cohesion,
			"equip": attacker.state_equipment,
			"moving": bool(env.get("attacker_moving", false))
		},
		"defender":
		{
			"id": defender.unit.id,
			"cs": defender.callsign,
			"pos_m": defender.position_m,
			"morale": defender.unit.morale,
			"strength": def_str,
			"cohesion": defender.cohesion,
			"equip": defender.state_equipment
		},
		"components": f.get("debug", {}),
		"mitigated_attack": mitigated_power
	}

	if debug_log_console:
		var c: Variant = dbg.components
		(
			LogService
			. info(
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
						str(dbg.attacker.cs),
						float(dbg.attacker.strength),
						float(dbg.attacker.morale),
						str(dbg.defender.cs),
						float(dbg.defender.strength),
						float(dbg.defender.morale)
					]
				)
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


## Computes the effective attack value for an attacker using equipment + ammo state.
func _compute_dynamic_attack_power(attacker: ScenarioUnit) -> float:
	if attacker == null or attacker.unit == null:
		return 0.0

	var unit: UnitData = attacker.unit
	var base_attack: float = float(unit.attack)
	if unit.has_method("compute_attack_power"):
		base_attack = float(unit.compute_attack_power(ammo_damage_config))
	base_attack = max(base_attack, 0.0)

	var morale_factor: float = clamp(unit.morale, 0.1, 1.25)
	var cohesion_factor: float = lerp(0.35, 1.0, clamp(attacker.cohesion, 0.0, 1.0))
	var equipment_factor: float = lerp(0.4, 1.0, clamp(attacker.state_equipment, 0.0, 1.0))
	var movement_factor: float = 1.0
	if attacker.move_state() == ScenarioUnit.MoveState.MOVING:
		movement_factor = 0.9

	return base_attack * morale_factor * cohesion_factor * equipment_factor * movement_factor


## Computes the defender's mitigation modifier that scales incoming damage.
func _compute_dynamic_defense_value(defender: ScenarioUnit) -> float:
	if defender == null or defender.unit == null:
		return 0.0

	var unit: UnitData = defender.unit
	var base_defense: float = max(unit.defense, 0.0)
	var morale_factor: float = lerp(0.4, 1.0, clamp(unit.morale, 0.0, 1.0))
	var cohesion_factor: float = lerp(0.4, 1.0, clamp(defender.cohesion, 0.0, 1.0))
	var equipment_factor: float = lerp(0.35, 1.0, clamp(defender.state_equipment, 0.0, 1.0))
	var movement_factor: float = 1.0
	if defender.move_state() == ScenarioUnit.MoveState.MOVING:
		movement_factor = 0.75

	return base_defense * morale_factor * cohesion_factor * equipment_factor * movement_factor


## Applies the defense modifier to the pending damage value.
func _apply_defense_modifier_to_damage(attack_value: float, defense_value: float) -> float:
	var atk: float = max(attack_value, 0.0)
	if atk <= 0.0:
		return 0.0
	var reduction_ratio: float = 0.0
	if defense_value > 0.0:
		reduction_ratio = defense_value / (defense_value + atk)
	var clamped: float = clamp(reduction_ratio, 0.0, 0.85)
	var mitigated: float = atk * (1.0 - clamped)
	# Always allow some minimal effect so defense never blocks 100% of the damage.
	return max(mitigated, atk * 0.05)


## Returns true when the attacker has the means to harm armored vehicles.
func _attacker_can_damage_vehicle(attacker: ScenarioUnit) -> bool:
	if attacker == null or attacker.unit == null:
		return false
	if attacker.unit.has_method("has_anti_vehicle_weapons"):
		return attacker.unit.has_anti_vehicle_weapons()
	return false


## Returns true when the defender should be treated as a vehicle for damage resolution.
func _is_vehicle_target(defender: ScenarioUnit) -> bool:
	if defender == null or defender.unit == null:
		return false
	if defender.unit.has_method("is_vehicle_unit"):
		return defender.unit.is_vehicle_unit()
	return false


## Applies vehicle-specific damage/destruction logic when applicable.
func _apply_vehicle_damage_resolution(attacker: ScenarioUnit, defender: ScenarioUnit, damage_value):
	if damage_value <= 0.0:
		return
	if not _is_vehicle_target(defender):
		return
	if not _attacker_can_damage_vehicle(attacker):
		return

	var vehicle_damage: float = damage_value
	if ammo_damage_config and attacker and attacker.unit:
		var weapon_ammo: Dictionary = attacker.unit.get_weapon_ammo_types()
		var highest_profile: float = 0.0
		for ammo_key in weapon_ammo.keys():
			highest_profile = max(
				highest_profile, ammo_damage_config.get_vehicle_damage_for(String(ammo_key))
			)
		if highest_profile > 0.0:
			vehicle_damage *= clamp(highest_profile * 0.05, 0.25, 3.0)

	var equipment_loss: float = clamp(vehicle_damage * 0.01, 0.0, 1.0)
	defender.state_equipment = max(defender.state_equipment - equipment_loss, 0.0)

	if defender.state_equipment <= 0.05:
		var catastrophic_loss: int = int(max(1.0, floor(vehicle_damage * 0.02)))
		_apply_casualties(defender, catastrophic_loss)


## Picks an ammo type + round count based on the attacker's current weapon mix.
func _select_ammo_profile_for_attack(attacker: ScenarioUnit, defender: ScenarioUnit) -> Dictionary:
	var unit := attacker.unit
	if unit == null:
		return {"ammo_type": "SMALL_ARMS", "rounds": 5}

	var ammo_counts: Dictionary = {}
	if unit.has_method("get_weapon_ammo_types"):
		ammo_counts = unit.get_weapon_ammo_types()

	if ammo_counts.is_empty():
		return {"ammo_type": "", "rounds": 0}

	var prefer_anti_vehicle := _is_vehicle_target(defender)
	var best_ammo := "SMALL_ARMS"
	var best_score: float = -INF
	var fallback_ammo := "SMALL_ARMS"
	var fallback_score: float = -INF
	for ammo_key in ammo_counts.keys():
		var qty := int(ammo_counts.get(ammo_key, 0))
		if qty <= 0:
			continue

		var has_stock := true
		if attacker.state_ammunition.has(ammo_key):
			has_stock = int(attacker.state_ammunition.get(ammo_key, 0)) > 0
		elif attacker.state_ammunition.has(ammo_key.to_lower()):
			has_stock = int(attacker.state_ammunition.get(ammo_key.to_lower(), 0)) > 0
		if not has_stock:
			continue

		var anti_capable := (
			ammo_damage_config != null and ammo_damage_config.is_anti_vehicle(String(ammo_key))
		)

		var score := float(qty)
		if anti_capable:
			var profile_bonus := 0.0
			if ammo_damage_config:
				profile_bonus = ammo_damage_config.get_vehicle_damage_for(String(ammo_key))
			score += profile_bonus

		if prefer_anti_vehicle and anti_capable:
			if score > best_score:
				best_score = score
				best_ammo = String(ammo_key)
		else:
			if score > fallback_score:
				fallback_score = score
				fallback_ammo = String(ammo_key)

	if prefer_anti_vehicle:
		if best_score == -INF:
			best_ammo = fallback_ammo
			best_score = fallback_score
	else:
		best_ammo = fallback_ammo
		best_score = fallback_score

	if best_score == -INF:
		return {"ammo_type": "", "rounds": 0}

	if best_score <= 0:
		best_score = 5

	var rounds: int = clamp(int(round(best_score)), 1, 10)
	return {"ammo_type": best_ammo, "rounds": rounds}
