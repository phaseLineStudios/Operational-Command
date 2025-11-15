# MovementAdapter::_step_move Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 435–454)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _step_move(dt: float) -> void
```

## Source

```gdscript
func _step_move(dt: float) -> void:
	var speed: float = base_speed_mps * _speed_mult
	var pos: Vector3 = _actor.global_position
	var to_target: Vector3 = _move_target - pos
	var dist: float = to_target.length()

	if dist <= arrive_epsilon:
		_moving = false
		return

	var dir: Vector3 = to_target / max(dist, 0.0001)
	if rotate_to_velocity and dir.length() > 0.001:
		# Keep y up, rotate on horizontal plane
		var flat: Vector3 = Vector3(dir.x, 0.0, dir.z).normalized()
		if flat.length() > 0.001:
			_actor.look_at(_actor.global_position + flat, Vector3.UP)

	_actor.global_position = pos + dir * speed * dt
```
