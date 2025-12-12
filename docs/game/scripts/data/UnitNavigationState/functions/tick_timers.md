# UnitNavigationState::tick_timers Function Reference

*Defined at:* `scripts/data/UnitNavigationState.gd` (lines 45–52)</br>
*Belongs to:* [UnitNavigationState](../../UnitNavigationState.md)

**Signature**

```gdscript
func tick_timers(dt: float) -> void
```

## Description

Advance timers for lost/bogged state.

## Source

```gdscript
func tick_timers(dt: float) -> void:
	var clamped_dt: float = max(dt, 0.0)
	if is_lost:
		lost_timer_s += clamped_dt
	if nav_state in [NavState.SLOWED, NavState.BOGGED, NavState.STUCK_SOFT]:
		bogged_timer_s += clamped_dt
```
