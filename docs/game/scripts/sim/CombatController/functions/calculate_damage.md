# CombatController::calculate_damage Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 119–208)</br>
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
	if dist_m > attacker.unit.spot_m * float(f.get("spotting_mul", 1.0)):
		return 0.0

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
	var fire := _gate_and_consume(attacker.unit, "small_arms", 5)
	if not bool(fire.get("allow", true)):
		LogService.info("%s cannot fire: out of ammo" % attacker.unit.id, "Combat")
		return 0.0

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
		return raw_loss
	else:
		var applied2 := _apply_casualties(defender.unit, 1)
		if attacker.unit.morale > 0.0 and applied2 == 0:
			attacker.unit.morale = max(0.0, attacker.unit.morale - 0.02)
		return 1.0
```
