# CombatController::_apply_defense_modifier_to_damage Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 521–533)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _apply_defense_modifier_to_damage(attack_value: float, defense_value: float) -> float
```

## Description

Applies the defense modifier to the pending damage value.

## Source

```gdscript
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
```
