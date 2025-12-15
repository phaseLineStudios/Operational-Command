# Game::_apply_video_perf_settings Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 86–147)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func _apply_video_perf_settings() -> void
```

## Source

```gdscript
func _apply_video_perf_settings() -> void:
	var root_viewport := get_tree().root
	if root_viewport == null:
		return

	var cfg := ConfigFile.new()
	cfg.load(_SETTINGS_PATH)

	var scale_pct: float = float(cfg.get_value("video", "scale_pct", 100.0))
	var res_idx: int = int(cfg.get_value("video", "res_index", 0))

	var window: Window = get_window()
	var window_size: Vector2i = window.size if window != null else Vector2i.ZERO
	if window_size.x <= 0 or window_size.y <= 0:
		window_size = root_viewport.size

	var target_size: Vector2i = window_size
	if res_idx >= 0 and res_idx < _DEFAULT_RESOLUTIONS.size():
		target_size = _DEFAULT_RESOLUTIONS[res_idx]

	var content_size: Vector2i = _compute_content_scale_size(window_size, target_size)
	if window != null:
		window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		window.content_scale_size = content_size

	var user_scale: float = clampf(scale_pct / 100.0, 0.1, 2.0)
	var final_scale: float = user_scale

	root_viewport.scaling_3d_mode = (
		Viewport.SCALING_3D_MODE_FSR if final_scale < 0.999 else Viewport.SCALING_3D_MODE_BILINEAR
	)
	root_viewport.scaling_3d_scale = final_scale

	# Adaptive MSAA (helps a lot at 1440p/4K fullscreen).
	var px: float = float(maxi(content_size.x, 1)) * float(maxi(content_size.y, 1))
	px *= final_scale * final_scale
	if px >= 3_500_000.0:
		root_viewport.msaa_3d = Viewport.MSAA_DISABLED
	elif px >= 2_000_000.0:
		root_viewport.msaa_3d = Viewport.MSAA_2X
	elif _base_msaa_3d >= 0:
		root_viewport.msaa_3d = _base_msaa_3d as Viewport.MSAA

	LogService.info(
		(
			"VideoPerf: win=%dx%d content=%dx%d target=%dx%d scale=%.2f msaa3d=%d"
			% [
				window_size.x,
				window_size.y,
				content_size.x,
				content_size.y,
				target_size.x,
				target_size.y,
				final_scale,
				root_viewport.msaa_3d
			]
		),
		"Game"
	)
```
