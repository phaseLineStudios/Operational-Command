# ScenarioUnit::tick Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 141–177)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func tick(dt: float, grid: PathGrid) -> void
```

## Description

Advance movement by dt seconds on PathGrid (virtual position only).

## Source

```gdscript
func tick(dt: float, grid: PathGrid) -> void:
	if _move_state != MoveState.MOVING or _move_paused or _move_path.is_empty():
		return

	var cur := position_m
	var speed := _speed_here_mps(grid, cur)
	if speed <= 0.0:
		_move_state = MoveState.BLOCKED
		emit_signal("move_blocked", "blocked_cell")
		return

	var remain := speed * dt
	while remain > 0.0 and _move_path_idx < _move_path.size():
		var tgt := _move_path[_move_path_idx]
		var d := cur.distance_to(tgt)
		if d <= remain:
			remain -= d
			cur = tgt
			_move_path_idx += 1
		else:
			var dir := (tgt - cur).normalized()
			cur += dir * remain
			remain = 0.0

	position_m = cur
	_move_last_eta_s = estimate_eta_s(grid)
	emit_signal("move_progress", position_m, _move_last_eta_s)

	if (
		_move_path_idx >= _move_path.size()
		or position_m.distance_to(_move_dest_m) <= ARRIVE_EPSILON
	):
		_move_state = MoveState.ARRIVED
		position_m = _move_dest_m
		emit_signal("move_arrived", _move_dest_m)
```
