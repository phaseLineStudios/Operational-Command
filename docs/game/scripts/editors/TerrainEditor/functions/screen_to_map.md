# TerrainEditor::screen_to_map Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 498–524)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func screen_to_map(pos: Vector2, keep_aspect: bool = true) -> Vector2
```

## Description

API to convert a screen-space point to terrain-local meters,

## Source

```gdscript
func screen_to_map(pos: Vector2, keep_aspect: bool = true) -> Vector2:
	var sv := terrainview
	if sv == null:
		return Vector2.INF

	var cont_rect := terrainview_container.get_global_rect()
	var sv_size: Vector2 = sv.size

	var draw_pos: Vector2
	var p_scale: Vector2
	if keep_aspect:
		var s: float = min(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)
		var draw_size: Vector2 = sv_size * s
		draw_pos = cont_rect.position + (cont_rect.size - draw_size) * 0.5
		p_scale = Vector2(s, s)
	else:
		draw_pos = cont_rect.position
		p_scale = Vector2(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)

	var sv_pos := (pos - draw_pos) / p_scale

	var to_local_xform := terrain_render.get_global_transform_with_canvas().affine_inverse()
	var local_px := to_local_xform * sv_pos

	return local_px
```
