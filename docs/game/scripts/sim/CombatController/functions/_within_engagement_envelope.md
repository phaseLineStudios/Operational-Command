# CombatController::_within_engagement_envelope Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 363–369)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool
```

## Description

True if attacker is permitted to fire at defender at distance 'dist_m'.
Note: LOS/spotting is already checked via LOSAdapter before combat resolution.
This only checks if target is within weapon engagement range.

## Source

```gdscript
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool:
	var engage_m := attacker.unit.range_m
	if engage_m <= 0.0:
		return false
	return dist_m <= engage_m + 0.5
```
