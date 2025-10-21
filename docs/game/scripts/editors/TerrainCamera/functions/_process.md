# TerrainCamera::_process Function Reference

*Defined at:* `scripts/editors/TerrainCamera.gd` (lines 44–53)</br>
*Belongs to:* [TerrainCamera](../../TerrainCamera.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
	if !_panning:
		return
	# Absolute (anchor-based) world-space pan — no per-frame accumulation
	var now_world := get_global_mouse_position()
	_delta_world += _pan_mouse_world_start - now_world
	var dir := -1.0 if invert_pan else 1.0
	position = _pan_cam_start + dir * _delta_world * pan_speed
```
