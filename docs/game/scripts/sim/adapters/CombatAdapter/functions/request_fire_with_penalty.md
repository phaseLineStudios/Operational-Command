# CombatAdapter::request_fire_with_penalty Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 131–161)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func request_fire_with_penalty(unit_id: String, ammo_type: String, rounds: int = 1) -> Dictionary
```

## Description

Request to fire *and* return penalty info for the caller to apply to accuracy/ROF/etc.
Example use in combat:
var r := _adapter.request_fire_with_penalty(attacker.id, "small_arms", 5)
if r.allow:
accuracy *= r.attack_power_mult
cycle_time *= r.attack_cycle_mult
suppression *= r.suppression_mult
# optionally apply r.morale_delta and heed r.ai_recommendation

## Source

```gdscript
func request_fire_with_penalty(unit_id: String, ammo_type: String, rounds: int = 1) -> Dictionary:
	var pen := get_ammo_penalty(unit_id, ammo_type)
	var allow := false
	match _roe:
		0:
			allow = false
		1:
			allow = _saw_hostile_shot
		2:
			allow = true
	if not allow:
		return {
			"allow": false,
			"state": "roe_blocked",
			"attack_power_mult": 1.0,
			"attack_cycle_mult": 1.0,
			"suppression_mult": 1.0,
			"morale_delta": 0,
			"ai_recommendation": "hold"
		}
	return {
		"allow": request_fire(unit_id, ammo_type, rounds),
		"state": pen.state,
		"attack_power_mult": pen.attack_power_mult,
		"attack_cycle_mult": pen.attack_cycle_mult,
		"suppression_mult": pen.suppression_mult,
		"morale_delta": pen.morale_delta,
		"ai_recommendation": pen.ai_recommendation,
	}
```
