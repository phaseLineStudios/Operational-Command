# LOSAdapter::sample_visibility_for_unit Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 209–215)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func sample_visibility_for_unit(_unit: ScenarioUnit) -> float
```

## Description

Fast local visibility query placeholder for EnvBehaviorSystem.

## Source

```gdscript
func sample_visibility_for_unit(_unit: ScenarioUnit) -> float:
	if _unit == null:
		return 1.0
	var pos_m: Vector2 = _unit.position_m if "position_m" in _unit else Vector2.ZERO
	return sample_visibility_at(pos_m)
```
