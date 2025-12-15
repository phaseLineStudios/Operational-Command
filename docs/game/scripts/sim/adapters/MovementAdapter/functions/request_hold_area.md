# MovementAdapter::request_hold_area Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 379–397)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func request_hold_area(center: Vector3, radius: float) -> void
```

## Description

TaskDefend

## Source

```gdscript
func request_hold_area(center: Vector3, radius: float) -> void:
	_patrol_running = false
	_holding = true
	_hold_center = center
	_hold_radius = max(radius, 0.0)
	_hold_timer = 0.0

	# If outside radius, move to nearest point on the circle, else stop immediately and start settling
	if _actor != null:
		var offset: Vector3 = _actor.global_position - center
		var dist: float = offset.length()
		if dist > _hold_radius + arrive_epsilon:
			var dir: Vector3 = offset.normalized()
			_move_target = center + dir * _hold_radius
			_moving = true
		else:
			_moving = false
```
