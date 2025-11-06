# ScenarioEditorOverlay::_draw_drawings Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 450–499)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_drawings() -> void
```

## Description

Draw scenario drawings (strokes and stamps).

## Source

```gdscript
func _draw_drawings() -> void:
	if not editor or not editor.ctx or not editor.ctx.data:
		return
	var arr: Array = editor.ctx.data.drawings
	if arr == null or arr.is_empty():
		return
	var sorted := arr.duplicate()
	sorted.sort_custom(
		func(a, b):
			var la: int = a.layer if a is Resource else int(a.get("layer"))
			var lb: int = b.layer if b is Resource else int(b.get("layer"))
			if la != lb:
				return la < lb
			var oa: int = a.order if a is Resource else int(a.get("order"))
			var ob: int = b.order if b is Resource else int(b.get("order"))
			return oa < ob
	)

	for it in sorted:
		if it == null:
			continue
		if it is ScenarioDrawingStroke:
			if not it.visible or it.points_m.is_empty():
				continue
			var col: Color = it.color
			col.a *= it.opacity
			var last_px := Vector2.INF
			for p_m in it.points_m:
				var p_px := editor.terrain_render.terrain_to_map(p_m)
				if last_px.is_finite():
					draw_line(last_px, p_px, col, it.width_px, true)
				last_px = p_px
		elif it is ScenarioDrawingStamp:
			if not it.visible:
				continue
			var tex := _get_tex(it.texture_path)
			if tex:
				var pos_px := editor.terrain_render.terrain_to_map(it.position_m)
				var sz: Vector2 = tex.get_size() * it.scale
				var tint: Color = it.modulate
				tint.a *= it.opacity
				draw_set_transform(pos_px, deg_to_rad(it.rotation_deg))
				draw_texture_rect(tex, Rect2(-sz * 0.5, sz), false, tint)
				draw_set_transform(Vector2(0, 0))

				# Draw label to the right of the stamp if present
				if it.label != null and it.label != "":
					_draw_stamp_label(it.label, pos_px, sz.x * 0.5, tint)
```
