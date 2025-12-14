# PickupItem::_process Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 239–259)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	if not _inspecting or _inspect_camera == null or not is_instance_valid(_inspect_camera):
		return

	var cam_t: Transform3D = _inspect_camera.global_transform
	var target_t := cam_t * Transform3D(Basis(), inspect_offset)

	var local_rot_rad := inspect_rotation * deg_to_rad(1.0)
	var rel_basis := Basis.from_euler(local_rot_rad)
	target_t.basis = cam_t.basis * rel_basis

	if inspect_smooth > 0.0:
		var a: float = clamp(inspect_smooth * delta, 0.0, 1.0)
		global_transform.origin = global_transform.origin.lerp(target_t.origin, a)
		var q_from := global_transform.basis.get_rotation_quaternion()
		var q_to := target_t.basis.get_rotation_quaternion()
		global_transform.basis = Basis(q_from.slerp(q_to, a))
	else:
		global_transform = target_t
```
