# UnitNavigationState::reset Function Reference

*Defined at:* `scripts/data/UnitNavigationState.gd` (lines 17–25)</br>
*Belongs to:* [UnitNavigationState](../../UnitNavigationState.md)

**Signature**

```gdscript
func reset() -> void
```

## Description

Reset all transient navigation flags.

## Source

```gdscript
func reset() -> void:
	nav_state = NavState.NORMAL
	is_lost = false
	drift_vector = Vector2.ZERO
	lost_timer_s = 0.0
	bogged_timer_s = 0.0
	navigation_bias = &"shortest"
```
