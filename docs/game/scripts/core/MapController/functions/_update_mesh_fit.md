# MapController::_update_mesh_fit Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 442–468)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _update_mesh_fit() -> void
```

## Description

Fit PlaneMesh to the viewport aspect ratio, clamped to _start_world_max

## Source

```gdscript
func _update_mesh_fit() -> void:
	var tex_size := Vector2(terrain_viewport.size)
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return

	var target_r := tex_size.x / tex_size.y
	var max_w := _start_world_max.x
	var max_h := _start_world_max.y

	var fit_w := max_w
	var fit_h := fit_w / target_r
	if fit_h > max_h:
		fit_h = max_h
		fit_w = fit_h * target_r

	var sx: float = abs(map.scale.x)
	if sx == 0.0:
		sx = 1.0
	var sz: float = abs(map.scale.z)
	if sz == 0.0:
		sz = 1.0
	_plane.size = Vector2(fit_w / sx, fit_h / sz)
	map.mesh = _plane

	emit_signal("map_resized", Vector2(fit_w, fit_h))
```
