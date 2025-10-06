# CombatController::_gate_and_consume Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 252–280)</br>
*Belongs to:* [CombatController](../CombatController.md)

**Signature**

```gdscript
func _gate_and_consume(attacker: UnitData, ammo_type: String, rounds: int) -> Dictionary
```

## Description

Gate a fire attempt by ammunition and consume rounds when allowed.

Returns a Dictionary with at least:
{ allow: bool, state: String, attack_power_mult: float,
attack_cycle_mult: float, suppression_mult: float, morale_delta: int,
ai_recommendation: String }

Behavior:
- If `_adapter` is null → allow=true with neutral multipliers (keeps tests running).
- If `CombatAdapter.request_fire_with_penalty()` exists → use it.
- Else fall back to `request_fire()` and map to a neutral response.

## Source

```gdscript
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
```
