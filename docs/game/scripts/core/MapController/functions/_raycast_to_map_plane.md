# MapController::_raycast_to_map_plane Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 508–523)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _raycast_to_map_plane(screen_pos: Vector2) -> Variant
```

## Description

World-space hit on the plane under a screen position; null if none

## Source

```gdscript
func _raycast_to_map_plane(screen_pos: Vector2) -> Variant:
	if _camera == null:
		_camera = get_viewport().get_camera_3d()
	if _camera == null or map == null or map.mesh == null:
		return null
	var ray_from := _camera.project_ray_origin(screen_pos)
	var ray_dir := _camera.project_ray_normal(screen_pos)
	if ray_dir == Vector3.ZERO:
		return null
	var plane_normal := map.global_transform.basis.y
	if plane_normal.length() <= 0.0001:
		return null
	var plane := Plane(plane_normal.normalized(), map.global_transform.origin)
	return plane.intersects_ray(ray_from, ray_dir)
```
