# MapController::_update_viewport_to_renderer Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 401–440)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _update_viewport_to_renderer() -> void
```

## Description

Resize the Viewport to match the renderer's pixel size (including margins)

## Source

```gdscript
func _update_viewport_to_renderer() -> void:
	if renderer == null:
		return
	var logical := renderer.size
	var logical_w: int = max(1, int(ceil(logical.x)))
	var logical_h: int = max(1, int(ceil(logical.y)))

	var os: int = max(viewport_oversample, 1)
	var chosen_scale: float = float(os)

	if viewport_max_size_px.x > 0 and viewport_max_size_px.y > 0:
		var max_scale_x: float = float(viewport_max_size_px.x) / float(logical_w)
		var max_scale_y: float = float(viewport_max_size_px.y) / float(logical_h)
		var max_scale: float = minf(max_scale_x, max_scale_y)
		if max_scale >= 1.0:
			# Prefer integer scaling to keep text crisp (avoids fractional canvas scaling blur).
			var max_int_scale: int = maxi(1, int(floor(max_scale)))
			var chosen_int: int = mini(os, max_int_scale)
			chosen_scale = float(chosen_int)
		else:
			# Too large to fit even at scale=1; downscale (fractional is unavoidable).
			chosen_scale = max_scale

	_viewport_pixel_scale = chosen_scale
	if _viewport_pixel_scale <= 0.0:
		_viewport_pixel_scale = 1.0

	var new_size := Vector2i(
		maxi(1, int(round(float(logical_w) * _viewport_pixel_scale))),
		maxi(1, int(round(float(logical_h) * _viewport_pixel_scale)))
	)
	if terrain_viewport.size != new_size:
		terrain_viewport.size = new_size

	# Scale the 2D canvas to match the chosen render target resolution.
	terrain_viewport.canvas_transform = Transform2D.IDENTITY.scaled(
		Vector2(_viewport_pixel_scale, _viewport_pixel_scale)
	)
```
