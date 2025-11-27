# InteractionController::_try_pickup Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 84–124)</br>
*Belongs to:* [InteractionController](../../InteractionController.md)

**Signature**

```gdscript
func _try_pickup(mouse_pos: Vector2) -> void
```

## Source

```gdscript
func _try_pickup(mouse_pos: Vector2) -> void:
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 10_000.0

	var space := camera.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collision_mask = pickable_mask
	params.collide_with_bodies = true
	params.collide_with_areas = true
	var hit := space.intersect_ray(params)
	if hit.size() == 0:
		return

	var col: Node3D = hit.collider
	var node: Node3D = null
	if col is Node3D:
		node = col
	else:
		return

	_held = node
	if _held.has_method("on_pickup"):
		_held.call("on_pickup")

	# Use the item's grab offset method if available, otherwise calculate manually
	if _held.has_method("get_grab_offset"):
		_grab_offset_local = _held.get_grab_offset(hit.position)
	else:
		_grab_offset_local = _held.to_local(hit.position)

	var p: Variant = _project_mouse_to_finite_plane(mouse_pos)
	if p != null:
		_last_valid_plane_point = p
		_have_valid_plane_point = true
		var world_offset := _held.global_transform.basis * _grab_offset_local
		_held.global_transform.origin = p - world_offset
	else:
		_have_valid_plane_point = false
```
