# TerrainElevationTool::_draw Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 272–299)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
	func _draw() -> void:
		var r_px := radius_m / meters_per_pixel
		var r_hard: float = r_px * clamp(falloff, 0.0, 1.0)
		var col_outer := Color(0.2, 0.6, 1.0, 0.8)
		var col_inner := Color(0.2, 0.6, 1.0, 0.4)
		var w_outer: float = clamp(r_px * 0.03, 1.0, 3.0)
		var w_inner: float = clamp(r_px * 0.02, 1.0, 2.0)
		draw_arc(
			Vector2.ZERO,
			r_px,
			0.0,
			TAU,
			int(clamp(r_px * 0.8, 24.0, 128.0)),
			col_outer,
			w_outer,
			antialias
		)
		if r_hard > 0.5:
			draw_arc(
				Vector2.ZERO,
				r_hard,
				0.0,
				TAU,
				int(clamp(r_px * 0.8, 24.0, 128.0)),
				col_inner,
				w_inner,
				antialias
			)
```
