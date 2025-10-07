# CombatAdapter::get_ammo_penalty Function Reference

*Defined at:* `scripts/sim/CombatAdapter.gd` (lines 55–104)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func get_ammo_penalty(unit_id: String, ammo_type: String) -> Dictionary
```

## Description

Compute penalty multipliers given the unit and ammo_type *without* consuming.
States:
- "normal": no penalty
- "low":     ≤ u.ammunition_low_threshold (and > critical)
- "critical":≤ u.ammunition_critical_threshold (and > 0)
- "empty":   == 0 (weapon is hard-blocked elsewhere)

Returns a Dictionary:
{
state: "normal"|"low"|"critical"|"empty",
attack_power_mult: float,  # 1.0 normal, 0.8 low, 0.5 critical
attack_cycle_mult: float, # 1.0 normal, 1.25 low, 1.5 critical (use to scale cycle/cooldown)
suppression_mult:  float, # 1.0 normal, 0.75 low, 0.0 critical (disable area fire)
morale_delta:      int,   # 0 normal, -10 low, -20 critical (apply in morale system if desired)
ai_recommendation: String # "normal"|"conserve"|"defensive"|"avoid"
}

## Source

```gdscript
func get_ammo_penalty(unit_id: String, ammo_type: String) -> Dictionary:
	var res := {
		"state": "normal",
		"attack_power_mult": 1.0,
		"attack_cycle_mult": 1.0,
		"suppression_mult": 1.0,
		"morale_delta": 0,
		"ai_recommendation": "normal",
	}

	if _ammo == null:
		return res
	var u := _ammo.get_unit(unit_id)
	if u == null or not u.state_ammunition.has(ammo_type):
		return res

	var cur: int = int(u.state_ammunition.get(ammo_type, 0))
	var cap: int = int(u.ammunition.get(ammo_type, 0))
	if cap <= 0:
		return res

	if cur <= 0:
		res.state = "empty"
		res.attack_power_mult = 0.0
		res.attack_cycle_mult = 2.0
		res.suppression_mult = 0.0
		res.morale_delta = -20
		res.ai_recommendation = "avoid"
		return res

	var ratio: float = float(cur) / float(cap)

	if ratio <= u.ammunition_critical_threshold:
		res.state = "critical"
		res.attack_power_mult = 0.5
		res.attack_cycle_mult = 1.5
		res.suppression_mult = 0.0
		res.morale_delta = -20
		res.ai_recommendation = "defensive"
	elif ratio <= u.ammunition_low_threshold:
		res.state = "low"
		res.attack_power_mult = 0.8
		res.attack_cycle_mult = 1.25
		res.suppression_mult = 0.75
		res.morale_delta = -10
		res.ai_recommendation = "conserve"

	return res
```
