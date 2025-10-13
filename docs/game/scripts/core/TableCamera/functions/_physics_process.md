# TableCamera::_physics_process Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 39–64)</br>
*Belongs to:* [TableCamera](../../TableCamera.md)

**Signature**

```gdscript
func _physics_process(delta: float) -> void
```

## Source

```gdscript
func _physics_process(delta: float) -> void:
	var input_vec := Vector2.ZERO
	input_vec.x = (
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	)
	input_vec.y = (
		int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	)
	if input_vec.length() > 0.0:
		input_vec = input_vec.normalized()

	var step2: Vector2 = input_vec * move_speed * delta
	_target_pos += Vector3(step2.x, 0.0, step2.y)
	_target_pos.y = bounds.position.y
	_target_pos = _clamp_vec3_to_bounds(_target_pos)

	camera.global_position = _damp_vec3(camera.global_position, _target_pos, move_smooth, delta)

	_clamp_to_bounds()

	_update_target_tilt_from_z()

	var new_x := _damp_scalar(camera.rotation.x, _target_tilt_rad, tilt_smooth, delta)
	camera.rotation.x = new_x
```
