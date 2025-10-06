# PathGrid::debug_draw_overlay Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 775–840)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func debug_draw_overlay(ci: CanvasItem) -> void
```

## Description

Render a grid overlay onto a CanvasItem (e.g., a Control). Coordinates are meters.

## Source

```gdscript
func debug_draw_overlay(ci: CanvasItem) -> void:
	if not debug_enabled or ci == null or _astar == null:
		return

	var region := _astar.region
	if region.size.x <= 0 or region.size.y <= 0:
		return

	var cs := cell_size_m
	var terrain_rect := Rect2(Vector2.ZERO, Vector2(region.size.x * cs, region.size.y * cs))
	var draw_rect := terrain_rect

	var x0: float = max(region.position.x, int(floor(draw_rect.position.x / cs)))
	var y0: float = max(region.position.y, int(floor(draw_rect.position.y / cs)))
	var x1: float = min(
		region.position.x + region.size.x - 1,
		int(floor((draw_rect.position.x + draw_rect.size.x - 0.0001) / cs))
	)
	var y1: float = min(
		region.position.y + region.size.y - 1,
		int(floor((draw_rect.position.y + draw_rect.size.y - 0.0001) / cs))
	)
	if x1 < x0 or y1 < y0:
		return

	for cy in range(y0, y1 + 1):
		for cx in range(x0, x1 + 1):
			var cell := Vector2i(cx, cy)
			if not _astar.is_in_boundsv(cell):
				continue

			var cell_rect := Rect2(Vector2(cx * cs, cy * cs), Vector2(cs, cs))
			var col := Color.TRANSPARENT

			match debug_layer:
				DebugLayer.SOLIDS:
					if _astar.is_point_solid(cell):
						col = Color(0.9, 0.2, 0.2, debug_alpha)

				DebugLayer.WEIGHT:
					if _astar.is_point_solid(cell):
						col = Color(0.9, 0.2, 0.2, debug_alpha)
					else:
						var w := _astar.get_point_weight_scale(cell)
						var t: float = clamp(w / max(0.001, debug_weight_vis_max), 0.0, 1.0)
						col = Color(t, t, 0.0, debug_alpha).lerp(Color(1, 0, 0, debug_alpha), t)

				DebugLayer.SLOPE:
					var s := debug_slope_mult_cell(cell)
					var t2: float = clamp((s - 1.0) / max(0.001, debug_weight_vis_max), 0.0, 1.0)
					col = Color(0.0, 0.4 + 0.6 * t2, 1.0, debug_alpha)

				DebugLayer.LINE_DIST:
					var d := debug_line_dist_cell(cell)
					if d < INF:
						var t3: float = clamp(
							1.0 - (d / max(1.0, line_influence_radius_m)), 0.0, 1.0
						)
						col = Color(1.0, 1.0 - t3, 0.0, debug_alpha)

			if col.a > 0.0:
				ci.draw_rect(cell_rect, col, true)
			if debug_cell_borders:
				ci.draw_rect(cell_rect, Color(0, 0, 0, 0.1), false)
```
