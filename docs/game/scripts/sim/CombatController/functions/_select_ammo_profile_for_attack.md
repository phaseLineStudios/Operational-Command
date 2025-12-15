# CombatController::_select_ammo_profile_for_attack Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 590–655)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _select_ammo_profile_for_attack(attacker: ScenarioUnit, defender: ScenarioUnit) -> Dictionary
```

## Description

Picks an ammo type + round count based on the attacker's current weapon mix.

## Source

```gdscript
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
```
