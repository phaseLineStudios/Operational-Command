# EnvBehaviorSystem::tick_units Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 54–72)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void
```

## Description

Main tick entry: update per-unit env behaviour.

## Source

```gdscript
func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void:
	if rng == null:
		return
	for su in units:
		if su == null or su.is_dead():
			continue
		var uid := String(su.id)
		var nav: UnitNavigationState = _nav_state_by_id.get(uid, null)
		if nav == null:
			nav = UnitNavigationState.new()
			_nav_state_by_id[uid] = nav

		nav.tick_timers(dt)

		var vis: float = _compute_visibility_score(su, scenario)
		_update_lost_state(su, nav, vis, rng, scenario)
		_update_slowdown_state(su, nav, rng)
```
