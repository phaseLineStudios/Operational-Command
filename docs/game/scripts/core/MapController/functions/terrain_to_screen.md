# MapController::terrain_to_screen Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 225–280)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func terrain_to_screen(terrain_pos: Vector2) -> Variant
```

- **terrain_pos**: Position in terrain meters
- **Return Value**: Screen position as Vector2, or null if position is not visible

## Description

Convert terrain position (meters) to screen position. Returns null if not visible

## Source

```gdscript
func terrain_to_screen(terrain_pos: Vector2) -> Variant:
	if renderer == null:
		return null

	# Convert terrain meters to map pixels
	var map_px: Vector2 = renderer.terrain_to_map(terrain_pos)

	# Apply oversample scaling
	var oversampled_px: Vector2 = map_px * float(max(viewport_oversample, 1))

	# Convert map pixels to UV coordinates (0-1)
	var vp := terrain_viewport.size
	if vp.x <= 0 or vp.y <= 0:
		return null
	var u := oversampled_px.x / vp.x
	var v := oversampled_px.y / vp.y

	# Convert UV to local plane coordinates
	if _plane == null:
		return null
	var local_x := (u - 0.5) * _plane.size.x
	var local_z := (v - 0.5) * _plane.size.y
	var local_pos := Vector3(local_x, 0.0, local_z)

	# Convert local to world coordinates
	if map == null:
		return null
	var world_pos := map.to_global(local_pos)

	# Project world position to screen
	if _camera == null:
		_camera = get_viewport().get_camera_3d()
	if _camera == null:
		return null

	# Check if position is behind camera
	var cam_to_pos := world_pos - _camera.global_position
	var forward := -_camera.global_transform.basis.z
	if cam_to_pos.dot(forward) <= 0.0:
		return null

	var screen_pos := _camera.unproject_position(world_pos)

	# Verify position is within viewport bounds
	var vp_size := get_viewport().get_visible_rect().size
	if (
		screen_pos.x < 0.0
		or screen_pos.y < 0.0
		or screen_pos.x > vp_size.x
		or screen_pos.y > vp_size.y
	):
		return null

	return screen_pos
```
