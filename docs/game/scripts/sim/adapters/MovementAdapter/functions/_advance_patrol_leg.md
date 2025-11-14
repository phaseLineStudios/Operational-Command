# MovementAdapter::_advance_patrol_leg Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 494–521)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _advance_patrol_leg() -> bool
```

## Source

```gdscript
func _advance_patrol_leg() -> bool:
	if _patrol_points.is_empty():
		return false
	if _patrol_segments_remaining <= 0:
		return false

	var n: int = _patrol_points.size()
	# Compute next index
	if _patrol_ping_pong:
		if _patrol_forward:
			if _patrol_index >= n - 1:
				_patrol_forward = false
				_patrol_index -= 1
			else:
				_patrol_index += 1
		else:
			if _patrol_index <= 0:
				_patrol_forward = true
				_patrol_index += 1
			else:
				_patrol_index -= 1
	else:
		_patrol_index = (_patrol_index + 1) % n

	_move_target = _patrol_points[_patrol_index]
	_moving = true
	_patrol_segments_remaining -= 1
	return true
```
