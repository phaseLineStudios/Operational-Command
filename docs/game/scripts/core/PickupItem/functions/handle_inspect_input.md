# PickupItem::handle_inspect_input Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 170–238)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func handle_inspect_input(event: InputEvent) -> bool
```

## Source

```gdscript
func handle_inspect_input(event: InputEvent) -> bool:
	if not _inspecting:
		return false

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		end_inspect()
		return true

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and document_viewport:
			var mouse_event := event as InputEventMouseButton
			if _inspect_camera == null or not is_instance_valid(_inspect_camera):
				return false

			var mouse_pos: Vector2 = mouse_event.position
			var from := _inspect_camera.project_ray_origin(mouse_pos)
			var dir := _inspect_camera.project_ray_normal(mouse_pos)
			var to := from + dir * 10_000.0

			var space := _inspect_camera.get_world_3d().direct_space_state
			var params := PhysicsRayQueryParameters3D.create(from, to)
			params.collide_with_bodies = true
			params.collision_mask = collision_layer
			var hit := space.intersect_ray(params)

			if hit.is_empty() or hit.collider != self:
				end_inspect()
				return true

			var uv := _get_document_uv_from_hit(hit)
			if uv != Vector2(-1, -1):
				var viewport_pos := uv * document_viewport_size

				var viewport_event := InputEventMouseButton.new()
				viewport_event.button_index = mouse_event.button_index
				viewport_event.pressed = mouse_event.pressed
				viewport_event.position = viewport_pos
				viewport_event.global_position = viewport_pos
				document_viewport.push_input(viewport_event)
				return true

		# Handle right clicks for closing inspect
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if _inspect_camera == null or not is_instance_valid(_inspect_camera):
				end_inspect()
				return true
			var mouse_pos: Vector2 = event.position
			var from := _inspect_camera.project_ray_origin(mouse_pos)
			var dir := _inspect_camera.project_ray_normal(mouse_pos)
			var to := from + dir * 10_000.0

			var space := _inspect_camera.get_world_3d().direct_space_state
			var params := PhysicsRayQueryParameters3D.create(from, to)
			params.collide_with_bodies = true
			params.collide_with_areas = true
			var hit := space.intersect_ray(params)

			var clicked_self := false
			if hit.size() > 0:
				var col: Variant = hit.collider
				if col is Node:
					clicked_self = (col == self) or self.is_ancestor_of(col)
			if not clicked_self:
				end_inspect()
			return true

	return false
```
