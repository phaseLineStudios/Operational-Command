# SymbolDrawingTool::_on_generate_pressed Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 312–471)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_generate_pressed() -> void
```

## Description

Generate GDScript code from shapes

## Source

```gdscript
func _on_generate_pressed() -> void:
	if _shapes.is_empty():
		code_output.text = "# No shapes placed yet. Add some shapes first!"
		return

	var code := ""
	code += "## Draw custom icon.\n"
	code += "## [param img] Image.\n"
	code += "## [param center] Center position.\n"
	code += "## [param size] Icon size.\n"
	code += "func _draw_custom_icon(img: Image, center: Vector2, size: float) -> void:\n"
	code += "\tvar half := size / 2.0\n"
	code += "\tvar thickness := 3.0\n"
	code += "\n"

	var center := Vector2(CANVAS_SIZE / 2.0, CANVAS_SIZE / 2.0)

	for shape_idx in range(_shapes.size()):
		var shape: Shape = _shapes[shape_idx]
		code += "\t# Shape %d: %s\n" % [shape_idx + 1, ShapeType.keys()[shape.type]]

		match shape.type:
			ShapeType.LINE:
				var p1 := _point_to_normalized(shape.start, center)
				var p2 := _point_to_normalized(shape.end, center)
				code += "\t_draw_thick_line(\n"
				code += (
					"\t\timg, Vector2(center.x %s, center.y %s),\n"
					% [_format_offset(p1.x), _format_offset(p1.y)]
				)
				code += (
					"\t\tVector2(center.x %s, center.y %s),\n"
					% [_format_offset(p2.x), _format_offset(p2.y)]
				)
				code += "\t\tCOLOR_FRAME, thickness\n"
				code += "\t)\n"

			ShapeType.CIRCLE:
				var circ_center := (shape.start + shape.end) / 2.0
				var radius := shape.start.distance_to(shape.end) / 2.0
				var norm_center := _point_to_normalized(circ_center, center)
				var norm_radius := radius / (ICON_AREA / 2.0)

				code += (
					"\tvar circle_center := Vector2(center.x %s, center.y %s)\n"
					% [_format_offset(norm_center.x), _format_offset(norm_center.y)]
				)
				code += "\tvar circle_radius := half * %.2f\n" % norm_radius

				if shape.filled:
					code += "\t_draw_filled_circle(img, circle_center, circle_radius, COLOR_FRAME)\n"
				else:
					code += (
						"\t_draw_circle_outline(img, circle_center, circle_radius, COLOR_FRAME, "
						+ "thickness)\n"
					)

			ShapeType.ELLIPSE:
				var ellipse_center := (shape.start + shape.end) / 2.0
				var rx: float = abs(shape.end.x - shape.start.x) / 2.0
				var ry: float = abs(shape.end.y - shape.start.y) / 2.0
				var norm_center := _point_to_normalized(ellipse_center, center)
				var norm_rx: float = rx / (ICON_AREA / 2.0)
				var norm_ry: float = ry / (ICON_AREA / 2.0)

				code += (
					"\tvar ellipse_center := Vector2(center.x %s, center.y %s)\n"
					% [_format_offset(norm_center.x), _format_offset(norm_center.y)]
				)
				code += "\tvar ellipse_rx := half * %.2f\n" % norm_rx
				code += "\tvar ellipse_ry := half * %.2f\n" % norm_ry

				if shape.filled:
					code += (
						"\t_draw_filled_ellipse(img, ellipse_center, ellipse_rx, "
						+ "ellipse_ry, COLOR_FRAME)\n"
					)
				else:
					code += (
						"\t_draw_ellipse_outline(img, ellipse_center, ellipse_rx, ellipse_ry, "
						+ "COLOR_FRAME, thickness)\n"
					)

			ShapeType.RECTANGLE:
				var rect := shape.get_bounds()
				var p1 := _point_to_normalized(rect.position, center)
				var p2 := _point_to_normalized(rect.position + rect.size, center)

				if shape.filled:
					code += "\t# Filled rectangle\n"
					code += (
						"\tfor y in range(int(center.y %s), int(center.y %s)):\n"
						% [_format_offset(p1.y), _format_offset(p2.y)]
					)
					code += (
						"\t\tfor x in range(int(center.x %s), int(center.x %s)):\n"
						% [_format_offset(p1.x), _format_offset(p2.x)]
					)
					code += ("\t\t\tif x >= 0 and x < SYMBOL_SIZE and y >= 0 and y < SYMBOL_SIZE:\n")
					code += "\t\t\t\timg.set_pixel(x, y, COLOR_FRAME)\n"
				else:
					# Draw four edges
					code += "\t# Rectangle outline\n"
					code += "\t# Top edge\n"
					code += "\t_draw_thick_line(\n"
					code += (
						"\t\timg, Vector2(center.x %s, center.y %s),\n"
						% [_format_offset(p1.x), _format_offset(p1.y)]
					)
					code += (
						"\t\tVector2(center.x %s, center.y %s),\n"
						% [_format_offset(p2.x), _format_offset(p1.y)]
					)
					code += "\t\tCOLOR_FRAME, thickness\n"
					code += "\t)\n"

					code += "\t# Bottom edge\n"
					code += "\t_draw_thick_line(\n"
					code += (
						"\t\timg, Vector2(center.x %s, center.y %s),\n"
						% [_format_offset(p1.x), _format_offset(p2.y)]
					)
					code += (
						"\t\tVector2(center.x %s, center.y %s),\n"
						% [_format_offset(p2.x), _format_offset(p2.y)]
					)
					code += "\t\tCOLOR_FRAME, thickness\n"
					code += "\t)\n"

					code += "\t# Left edge\n"
					code += "\t_draw_thick_line(\n"
					code += (
						"\t\timg, Vector2(center.x %s, center.y %s),\n"
						% [_format_offset(p1.x), _format_offset(p1.y)]
					)
					code += (
						"\t\tVector2(center.x %s, center.y %s),\n"
						% [_format_offset(p1.x), _format_offset(p2.y)]
					)
					code += "\t\tCOLOR_FRAME, thickness\n"
					code += "\t)\n"

					code += "\t# Right edge\n"
					code += "\t_draw_thick_line(\n"
					code += (
						"\t\timg, Vector2(center.x %s, center.y %s),\n"
						% [_format_offset(p2.x), _format_offset(p1.y)]
					)
					code += (
						"\t\tVector2(center.x %s, center.y %s),\n"
						% [_format_offset(p2.x), _format_offset(p2.y)]
					)
					code += "\t\tCOLOR_FRAME, thickness\n"
					code += "\t)\n"

		code += "\n"

	code_output.text = code
```
