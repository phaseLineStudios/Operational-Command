# DrawingController::_project_mouse_to_map Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 284–309)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _project_mouse_to_map(mouse_pos: Vector2) -> Variant
```

## Source

```gdscript
func _project_mouse_to_map(mouse_pos: Vector2) -> Variant:
	if not camera or not is_instance_valid(camera):
		return null

	if not map_mesh or not is_instance_valid(map_mesh):
		return null

	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)

	var map_transform := map_mesh.global_transform
	var plane_point := map_transform.origin
	var plane_normal := (map_transform.basis * Vector3.UP).normalized()

	var denom := plane_normal.dot(dir)
	if is_equal_approx(denom, 0.0):
		return null

	var t := plane_normal.dot(plane_point - from) / denom
	if t < 0.0:
		return null

	var hit_point := from + dir * t
	return hit_point
```
