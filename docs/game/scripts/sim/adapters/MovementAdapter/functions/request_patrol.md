# MovementAdapter::request_patrol Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 411–434)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func request_patrol(points: Array[Vector3], ping_pong: bool, loop_forever: bool = false) -> void
```

## Description

TaskPatrol

## Source

```gdscript
func request_patrol(points: Array[Vector3], ping_pong: bool, loop_forever: bool = false) -> void:
	_holding = false
	_patrol_points = points.duplicate()
	_patrol_ping_pong = ping_pong
	_patrol_index = 0
	_patrol_forward = true
	_patrol_dwell = 0.0
	_patrol_loop_forever = loop_forever
	_moving = false
	# One single cycle then stop:
	# cycle: visit each point once (N segments)
	# ping-pong: go to end and back without repeating endpoints (2*N-2 segments)
	var n: int = _patrol_points.size()
	if n <= 1:
		_patrol_running = false
		return
	_patrol_segments_remaining = n if not ping_pong else max(2 * n - 2, 1)
	_patrol_running = true
	# Set first leg
	_move_target = _patrol_points[1]
	_moving = true
	_patrol_index = 1
```
