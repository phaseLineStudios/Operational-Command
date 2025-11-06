# DrawingController::_process Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 69–98)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _process(_delta: float) -> void
```

## Source

```gdscript
func _process(_delta: float) -> void:
	# Update current tool based on what's held
	_update_current_tool()

	if not _is_drawing:
		return

	if _current_tool == Tool.NONE:
		return

	# Project mouse to map plane and add point to current stroke
	var mouse_pos := get_viewport().get_mouse_position()
	var world_pos: Variant = _project_mouse_to_map(mouse_pos)

	if world_pos != null:
		# Only add point if it's far enough from the last point
		if (
			_current_stroke.is_empty()
			or _last_point.distance_to(world_pos) > point_distance_threshold
		):
			_current_stroke.append(world_pos)
			_last_point = world_pos

			# If erasing, erase in real-time as we drag
			if _current_tool == Tool.ERASER:
				_erase_at_point(world_pos)

			_update_drawing_mesh()
```
