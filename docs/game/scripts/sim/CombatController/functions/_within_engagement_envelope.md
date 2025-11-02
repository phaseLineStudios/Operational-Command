# CombatController::_within_engagement_envelope Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 322–329)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool
```

## Description

True if attacker is permitted to fire at defender at distance 'dist_m'.

## Source

```gdscript
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool:
	var spot_m := attacker.unit.spot_m
	var engage_m := attacker.unit.range_m
	if spot_m <= 0.0 or engage_m <= 0.0:
		return false
	return (dist_m <= spot_m + 0.5) and (dist_m <= engage_m + 0.5)
```
