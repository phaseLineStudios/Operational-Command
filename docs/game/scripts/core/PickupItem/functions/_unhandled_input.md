# PickupItem::_unhandled_input Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 213–262)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Description

Handle unhandled input for document interaction

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if not document_viewport:
		return

	# Only handle mouse button clicks while inspecting
	if not _inspecting:
		return

	if not event is InputEventMouseButton:
		return

	var mouse_event := event as InputEventMouseButton

	# Only handle left clicks
	if mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return

	var camera := get_viewport().get_camera_3d()
	if not camera:
		return
	var mouse_pos := mouse_event.position
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 1000.0

	var space := get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collide_with_bodies = true
	params.collision_mask = collision_layer
	var hit := space.intersect_ray(params)

	if hit.is_empty() or hit.collider != self:
		return

	var uv := _get_document_uv_from_hit(hit)
	if uv == Vector2(-1, -1):
		return

	var viewport_pos := uv * document_viewport_size

	var viewport_event := InputEventMouseButton.new()
	viewport_event.button_index = mouse_event.button_index
	viewport_event.pressed = mouse_event.pressed
	viewport_event.position = viewport_pos
	viewport_event.global_position = viewport_pos
	document_viewport.push_input(viewport_event)

	get_viewport().set_input_as_handled()
```
