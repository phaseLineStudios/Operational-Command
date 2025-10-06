# InteractionController::_project_mouse_to_finite_plane Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 131–153)</br>
*Belongs to:* [InteractionController](../InteractionController.md)

**Signature**

```gdscript
func _project_mouse_to_finite_plane(mouse_pos: Vector2) -> Variant
```

## Source

```gdscript
func _project_mouse_to_finite_plane(mouse_pos: Vector2) -> Variant:
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)

	var gt := bounds.global_transform
	var world_point_on_plane := gt.origin
	var world_normal := (gt.basis * Vector3.UP).normalized()

	var denom := world_normal.dot(dir)
	if is_equal_approx(denom, 0.0):
		return null
	var t := world_normal.dot(world_point_on_plane - from) / denom
	if t < 0.0:
		return null
	var hit_world := from + dir * t

	var local := gt.affine_inverse() * hit_world
	if absf(local.y) > 0.01:
		return null
	if absf(local.x) > _half_x or absf(local.z) > _half_z:
		return null

	return hit_world
```
