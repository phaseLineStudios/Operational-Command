# ViewportReadOverlay::_map_global_to_viewport_pos Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 110–133)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func _map_global_to_viewport_pos(global_pos: Vector2) -> Vector2
```

## Source

```gdscript
func _map_global_to_viewport_pos(global_pos: Vector2) -> Vector2:
	if _texture_rect.texture == null:
		return Vector2.INF
	if _viewport_size.x <= 0 or _viewport_size.y <= 0:
		return Vector2.INF

	var rect := _texture_rect.get_global_rect()
	var tex_size: Vector2 = _texture_rect.texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return Vector2.INF

	var scale: float = minf(rect.size.x / tex_size.x, rect.size.y / tex_size.y)
	if scale <= 0.0:
		return Vector2.INF

	var draw_size: Vector2 = tex_size * scale
	var draw_pos: Vector2 = rect.position + (rect.size - draw_size) * 0.5
	var draw_rect := Rect2(draw_pos, draw_size)
	if not draw_rect.has_point(global_pos):
		return Vector2.INF

	var local_tex: Vector2 = (global_pos - draw_pos) / scale
	var vp_size_v2 := Vector2(_viewport_size)
	return Vector2(local_tex.x * vp_size_v2.x / tex_size.x, local_tex.y * vp_size_v2.y / tex_size.y)
```
