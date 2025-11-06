# MovementAdapter::plan_and_start_direct Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 236–253)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func plan_and_start_direct(su: ScenarioUnit, dest_m: Vector2) -> bool
```

- **su**: ScenarioUnit to move.
- **dest_m**: Destination in terrain meters.
- **Return Value**: True if planned (or deferred), false on error.

## Description

Plans and starts direct straight-line movement without pathfinding.
Defers start if the profile grid is still building.

## Source

```gdscript
func plan_and_start_direct(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("unit or grid null", "MovementAdapter.gd")
		return false
	var p := su.unit.movement_profile
	if not _grid.ensure_profile(p):
		su.set_meta("_pending_start_dest", dest_m)
		su.set_meta("_pending_start_profile", p)
		su.set_meta("_pending_start_direct", true)
		return true
	_grid.use_profile(p)
	if su.plan_direct_move(_grid, dest_m):
		su.start_move(_grid)
		return true
	LogService.warning("plan_direct_move failed", "MovementAdapter.gd")
	return false
```
