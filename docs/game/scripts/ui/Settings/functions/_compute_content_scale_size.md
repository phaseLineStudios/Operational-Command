# Settings::_compute_content_scale_size Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 359–375)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _compute_content_scale_size(window_size: Vector2i, target_size: Vector2i) -> Vector2i
```

## Source

```gdscript
func _compute_content_scale_size(window_size: Vector2i, target_size: Vector2i) -> Vector2i:
	var out: Vector2i = target_size
	if out.x <= 0 or out.y <= 0:
		out = window_size
	if out.x <= 0 or out.y <= 0:
		return Vector2i(1, 1)

	if window_size.x <= 0 or window_size.y <= 0:
		return out

	# Avoid supersampling when the window is smaller than the selected resolution.
	var sx: float = float(window_size.x) / float(out.x)
	var sy: float = float(window_size.y) / float(out.y)
	var s: float = minf(1.0, minf(sx, sy))
	return Vector2i(maxi(1, int(round(float(out.x) * s))), maxi(1, int(round(float(out.y) * s))))
```
