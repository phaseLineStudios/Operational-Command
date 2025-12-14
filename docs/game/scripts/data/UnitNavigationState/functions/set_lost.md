# UnitNavigationState::set_lost Function Reference

*Defined at:* `scripts/data/UnitNavigationState.gd` (lines 27–35)</br>
*Belongs to:* [UnitNavigationState](../../UnitNavigationState.md)

**Signature**

```gdscript
func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void
```

## Description

Mark unit as lost with an optional drift vector.

## Source

```gdscript
func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void:
	if state and not is_lost:
		lost_timer_s = 0.0
	is_lost = state
	drift_vector = drift if state else Vector2.ZERO
	if not state:
		lost_timer_s = 0.0
```
