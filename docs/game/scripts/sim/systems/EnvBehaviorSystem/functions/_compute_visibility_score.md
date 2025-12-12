# EnvBehaviorSystem::_compute_visibility_score Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 90–104)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _compute_visibility_score(unit: Variant, scenario: Variant) -> float
```

## Description

Compute visibility at a position for loss calculations.

## Source

```gdscript
func _compute_visibility_score(unit: Variant, scenario: Variant) -> float:
	var pos_m: Vector2 = unit.position_m if "position_m" in unit else Vector2.ZERO
	if visibility_profile and movement_adapter and movement_adapter.renderer:
		return visibility_profile.compute_visibility_score(
			movement_adapter.renderer, pos_m, scenario, int(unit.behaviour)
		)
	if visibility_profile and los_adapter:
		return visibility_profile.compute_visibility_score(
			los_adapter, pos_m, scenario, int(unit.behaviour)
		)
	if los_adapter and los_adapter.has_method("sample_visibility_at"):
		return los_adapter.sample_visibility_at(pos_m)
	return 1.0
```
