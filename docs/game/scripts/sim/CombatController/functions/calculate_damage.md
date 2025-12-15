# CombatController::calculate_damage Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 122–230)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> float
```

## Description

Combat damage calculation with terrain/environment multipliers + ammo
gating/penalties + ROF cooldown

## Source

```gdscript
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> float:
	if attacker == null or defender == null or attacker.unit == null or defender.unit == null:
		return 0.0

	# Dead units cannot attack or be attacked
	if attacker.is_dead() or defender.is_dead():
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
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.002)
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
		defender.unit.morale = max(0.0, defender.unit.morale - 0.01)
	elif attacker.unit.morale > 0.0 and applied <= 0:
		attacker.unit.morale = max(0.0, attacker.unit.morale - 0.005)

	# Mark defender as under fire (for auto-pause logic)
	if applied > 0:
		defender.mark_under_fire()

	_apply_vehicle_damage_resolution(attacker, defender, mitigated_attack)
	return raw_loss
```
