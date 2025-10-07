# TerrainCamera::_input Function Reference

*Defined at:* `scripts/editors/TerrainCamera.gd` (lines 24–43)</br>
*Belongs to:* [TerrainCamera](../../TerrainCamera.md)

**Signature**

```gdscript
func _input(event: InputEvent) -> void
```

## Source

```gdscript
func _input(event: InputEvent) -> void:
	# Toggle panning and record anchors
	if event is InputEventMouseButton and event.button_index == pan_button:
		_panning = event.pressed
		if _panning:
			_pan_cam_start = position
			_pan_mouse_world_start = get_global_mouse_position()
			_delta_world = Vector2.ZERO
		return

	# Zoom at the cursor
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at_mouse(1.0 - zoom_step)
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at_mouse(1.0 + zoom_step)
			return
```
