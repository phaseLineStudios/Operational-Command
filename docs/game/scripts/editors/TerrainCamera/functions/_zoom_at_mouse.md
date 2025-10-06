# TerrainCamera::_zoom_at_mouse Function Reference

*Defined at:* `scripts/editors/TerrainCamera.gd` (lines 54–69)</br>
*Belongs to:* [TerrainCamera](../TerrainCamera.md)

**Signature**

```gdscript
func _zoom_at_mouse(zoom_scale: float) -> void
```

## Source

```gdscript
func _zoom_at_mouse(zoom_scale: float) -> void:
	# Maintain cursor-anchored zoom (works fine during a pan, too)
	var before := get_global_mouse_position()

	var new_zoom := zoom * zoom_scale
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom

	var after := get_global_mouse_position()
	position += (before - after)

	# If zooming while panning, re-anchor so there’s zero jitter
	if _panning:
		_pan_cam_start = position
		_pan_mouse_world_start = get_global_mouse_position()
```
