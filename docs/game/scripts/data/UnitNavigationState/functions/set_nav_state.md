# UnitNavigationState::set_nav_state Function Reference

*Defined at:* `scripts/data/UnitNavigationState.gd` (lines 37–43)</br>
*Belongs to:* [UnitNavigationState](../../UnitNavigationState.md)

**Signature**

```gdscript
func set_nav_state(state: NavState) -> void
```

## Description

Set bogged/slow state and timers; resets when back to NORMAL.

## Source

```gdscript
func set_nav_state(state: NavState) -> void:
	if nav_state != state:
		if state == NavState.NORMAL:
			bogged_timer_s = 0.0
	nav_state = state
```
