# OCMenuButton::_draw_noise_overlay Function Reference

*Defined at:* `scripts/ui/controls/OcMenuButton.gd` (lines 74–88)</br>
*Belongs to:* [OCMenuButton](../../OCMenuButton.md)

**Signature**

```gdscript
func _draw_noise_overlay()
```

## Source

```gdscript
func _draw_noise_overlay():
	if not noise_enabled:
		return

	_rebuild_noise_tex()

	var noise_scale: Variant = max(1.0, _noise_grain)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(noise_scale, noise_scale))
	draw_texture_rect(
		_noise_tex,
		Rect2(Vector2(0, 0), size / noise_scale),
		true,
		Color(1, 1, 1, clamp(_noise_opacity, 0.0, 1.0))
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
