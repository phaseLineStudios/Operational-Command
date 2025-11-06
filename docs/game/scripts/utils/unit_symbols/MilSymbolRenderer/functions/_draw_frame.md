# MilSymbolRenderer::_draw_frame Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 86–125)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_frame() -> void
```

## Description

Draw the base frame geometry

## Source

```gdscript
func _draw_frame() -> void:
	var frame_color := config.get_frame_color(affiliation)
	var fill_color := config.get_fill_color(affiliation)

	# Check if this is a circle frame
	if MilSymbolGeometry.is_circle_frame(domain, affiliation):
		var params := MilSymbolGeometry.get_circle_params(domain, affiliation)
		var center: Vector2 = params[0]
		var radius: float = params[1]

		# Draw fill
		if config.filled:
			draw_circle(center, radius, fill_color)

		# Draw outline
		draw_arc(center, radius, 0, TAU, 64, frame_color, config.stroke_width)
	else:
		# Get polygon points
		var points: Array[Vector2]
		match domain:
			MilSymbolGeometry.Domain.GROUND:
				points = MilSymbolGeometry.get_ground_frame(affiliation)
			MilSymbolGeometry.Domain.AIR:
				points = MilSymbolGeometry.get_air_frame(affiliation)
			MilSymbolGeometry.Domain.SEA:
				points = MilSymbolGeometry.get_sea_frame(affiliation)
			_:
				points = MilSymbolGeometry.get_ground_frame(affiliation)

		if points.is_empty():
			return

		# Draw filled polygon
		if config.filled:
			draw_colored_polygon(points, fill_color * Color(1, 1, 1, config.fill_opacity))

		# Draw outline
		draw_polyline(points + [points[0]], frame_color, config.stroke_width)  # Close the polygon
```
