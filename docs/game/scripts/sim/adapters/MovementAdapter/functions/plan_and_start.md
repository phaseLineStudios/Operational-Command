# MovementAdapter::plan_and_start Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 214–230)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool
```

## Description

Plans and immediately starts movement to [param dest_m].
Defers start if the profile grid is still building.
[param su] ScenarioUnit to move.
[param dest_m] Destination in terrain meters.
[return] True if planned (or deferred), false on error or plan failure.

## Source

```gdscript
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("unit or grid null", "MovementAdapter.gd:151")
		return false
	var p := su.unit.movement_profile
	if not _grid.ensure_profile(p):
		su.set_meta("_pending_start_dest", dest_m)
		su.set_meta("_pending_start_profile", p)
		return true
	_grid.use_profile(p)
	if su.plan_move(_grid, dest_m):
		su.start_move(_grid)
		return true
	LogService.warning("plan_move failed", "MovementAdapter.gd:163")
	return false
```
