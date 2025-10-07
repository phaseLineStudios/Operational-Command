# TerrainElevationTool::_apply Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 151–219)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func _apply(pos: Vector2) -> void
```

## Description

Draw elevation change

## Source

```gdscript
func _apply(pos: Vector2) -> void:
	var img := data.elevation
	if img.is_empty():
		return

	if not pos.is_finite():
		return

	var local_terrain := editor.map_to_terrain(pos)
	var px := data.world_to_elev_px(local_terrain)

	var r_px := int(round(brush_radius_m / data.elevation_resolution_m))

	if _stroke_active and data and data.elevation and not data.elevation.is_empty():
		var cp := Vector2i(px.x, px.y)
		var rr := _brush_rect_px(cp, r_px, data.elevation)
		_stroke_rect = rr if _stroke_rect.size.x == 0 else _rect_union(_stroke_rect, rr)

	var r_px_i := int(round(r_px))
	var r_hard: float = r_px * clamp(falloff_p, 0.0, 1.0)
	var soft_band: float = max(r_px - r_hard, 0.0001)
	for y in range(-r_px_i, r_px_i + 1):
		for x in range(-r_px_i, r_px_i + 1):
			if (x * x + y * y) > int(r_px * r_px):
				continue

			var p := Vector2i(px.x + x, px.y + y)
			if p.x < 0 or p.y < 0 or p.x >= img.get_width() or p.y >= img.get_height():
				continue

			var d := sqrt(float(x * x + y * y))
			var w := 1.0
			if d > r_hard:
				var t := (d - r_hard) / soft_band
				w = 1.0 - _smooth01(t)

			if w <= 0.0:
				continue

			var e := img.get_pixel(p.x, p.y).r

			match mode:
				Mode.RAISE:
					e += strength_m * w
				Mode.LOWER:
					e -= strength_m * w
				Mode.SMOOTH:
					var sum := 0.0
					var cnt := 0
					for yy in range(-1, 2):
						for xx in range(-1, 2):
							var q := Vector2i(p.x + xx, p.y + yy)
							if (
								q.x < 0
								or q.y < 0
								or q.x >= img.get_width()
								or q.y >= img.get_height()
							):
								continue
							sum += img.get_pixel(q.x, q.y).r
							cnt += 1
					if cnt > 0:
						var avg := sum / cnt
						var alpha: float = clamp(0.5 * w * strength_m, 0.0, 1.0)
						e = lerp(e, avg, alpha)

			data.set_elev_px(p, e)
```
