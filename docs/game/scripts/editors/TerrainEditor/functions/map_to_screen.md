# TerrainEditor::map_to_screen Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 526–553)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func map_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2
```

## Description

API to convert terrain meters to a screen-space point

## Source

```gdscript
func map_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2:
	var sv := terrainview
	if sv == null:
		return Vector2.INF
	if not local_m.is_finite():
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

	var from_local_xform := terrain_render.get_global_transform_with_canvas()
	var sv_pos := from_local_xform * local_m

	var screen_pos := draw_pos + sv_pos * p_scale
	return screen_pos
```
