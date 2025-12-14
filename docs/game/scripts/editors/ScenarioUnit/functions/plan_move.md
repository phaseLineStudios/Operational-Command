# ScenarioUnit::plan_move Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 99–136)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func plan_move(grid: PathGrid, dest_m: Vector2) -> bool
```

## Description

Plan a path from current position to dest_m using PathGrid.

## Source

```gdscript
func plan_move(grid: PathGrid, dest_m: Vector2) -> bool:
	if grid == null:
		emit_signal("move_blocked", "no_grid")
		LogService.warning("move blocked: no_grid", "ScenarioUnit.gd:66")
		return false
	if unit == null:
		emit_signal("move_blocked", "no_unit")
		LogService.warning("move blocked: no_unit", "ScenarioUnit.gd:69")
		return false
	if unit.speed_kph <= 0.0:
		emit_signal("move_blocked", "no_speed")
		LogService.warning("move blocked: no_speed", "ScenarioUnit.gd:74")
		return false
	if position_m.distance_to(dest_m) <= ARRIVE_EPSILON:
		_move_dest_m = dest_m
		_move_path = [position_m, dest_m]
		_move_path_idx = 1
		_move_state = MoveState.ARRIVED
		position_m = dest_m
		emit_signal("move_arrived", dest_m)
		return true
	_move_dest_m = dest_m
	var p := grid.find_path_m(position_m, dest_m)
	if p.is_empty():
		_move_state = MoveState.BLOCKED
		_move_path = []
		_move_path_idx = 0
		emit_signal("move_blocked", "no_path")
		LogService.warning("move blocked: no_path", "ScenarioUnit.gd:91")
		return false
	_move_path = p
	_move_path_idx = 0
	_move_state = MoveState.PLANNING
	_move_last_eta_s = estimate_eta_s(grid)
	emit_signal("move_planned", dest_m, _move_last_eta_s)
	return true
```
