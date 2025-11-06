# ScenarioUnit::plan_direct_move Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 127–154)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func plan_direct_move(grid: PathGrid, dest_m: Vector2) -> bool
```

- **grid**: PathGrid (used for ETA estimation only).
- **dest_m**: Destination in terrain meters.
- **Return Value**: True if planned, false on error.

## Description

Plan a direct straight-line path without pathfinding.

## Source

```gdscript
func plan_direct_move(grid: PathGrid, dest_m: Vector2) -> bool:
	if unit == null:
		emit_signal("move_blocked", "no_unit")
		LogService.warning("move blocked: no_unit", "ScenarioUnit.gd")
		return false
	if unit.speed_kph <= 0.0:
		emit_signal("move_blocked", "no_speed")
		LogService.warning("move blocked: no_speed", "ScenarioUnit.gd")
		return false
	if position_m.distance_to(dest_m) <= ARRIVE_EPSILON:
		_move_dest_m = dest_m
		_move_path = [position_m, dest_m]
		_move_path_idx = 1
		_move_state = MoveState.ARRIVED
		position_m = dest_m
		emit_signal("move_arrived", dest_m)
		return true

	# Create simple two-point path (straight line)
	_move_dest_m = dest_m
	_move_path = [position_m, dest_m]
	_move_path_idx = 0
	_move_state = MoveState.PLANNING
	_move_last_eta_s = estimate_eta_s(grid)
	emit_signal("move_planned", dest_m, _move_last_eta_s)
	return true
```
