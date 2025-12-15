# Settings::_apply_adaptive_aa Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 338–358)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _apply_adaptive_aa(root_viewport: Viewport, render_size: Vector2i, final_scale: float) -> void
```

## Source

```gdscript
func _apply_adaptive_aa(root_viewport: Viewport, render_size: Vector2i, final_scale: float) -> void:
	if not auto_adjust_aa:
		if _base_msaa_3d >= 0:
			root_viewport.msaa_3d = _base_msaa_3d as Viewport.MSAA
		return

	# Estimate actual 3D render pixel count (roughly proportional to cost).
	var px: float = float(maxi(render_size.x, 1)) * float(maxi(render_size.y, 1))
	px *= final_scale * final_scale

	# Disable heavy MSAA at high resolutions (big fullscreen performance win).
	# 2560x1440 ~= 3.7M px, 3840x2160 ~= 8.3M px
	if px >= 3_500_000.0:
		root_viewport.msaa_3d = Viewport.MSAA_DISABLED
	elif px >= 2_000_000.0:
		root_viewport.msaa_3d = Viewport.MSAA_2X
	else:
		if _base_msaa_3d >= 0:
			root_viewport.msaa_3d = _base_msaa_3d as Viewport.MSAA
```
