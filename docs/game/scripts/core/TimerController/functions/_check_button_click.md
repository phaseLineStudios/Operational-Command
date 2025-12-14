# TimerController::_check_button_click Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 183–212)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _check_button_click(mouse_pos: Vector2) -> void
```

## Description

Check if a button was clicked and handle it.

## Source

```gdscript
func _check_button_click(mouse_pos: Vector2) -> void:
	if camera == null or _skeleton == null:
		return

	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 10_000.0

	var space := camera.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collision_mask = button_mask
	params.collide_with_bodies = true
	params.collide_with_areas = true

	var hit := space.intersect_ray(params)
	if hit.is_empty():
		return

	var collider: Node = hit.collider
	if not _is_child_of_timer(collider):
		return

	var hit_local := timer.to_local(hit.position)
	var clicked_bone := _get_closest_button_bone(hit_local)

	if clicked_bone >= 0:
		_on_button_pressed(clicked_bone)
		get_viewport().set_input_as_handled()
```
