# MilSymbolRenderer::_draw_icon_path Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 176–260)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_icon_path(path_data: String, color: Color, filled: bool) -> void
```

## Description

Draw icon from SVG path data
Supports basic SVG path commands: M, L, H, V, C, Z

## Source

```gdscript
func _draw_icon_path(path_data: String, color: Color, filled: bool) -> void:
	var points: PackedVector2Array = PackedVector2Array()
	var current_pos := Vector2.ZERO
	var start_pos := Vector2.ZERO

	# Simple SVG path parser
	var commands := path_data.split(" ")
	var i := 0

	while i < commands.size():
		var cmd := commands[i].strip_edges()
		if cmd.is_empty():
			i += 1
			continue

		match cmd:
			"M":  # Move to absolute
				if i + 1 < commands.size():
					var coords := _parse_coord(commands[i + 1])
					current_pos = coords
					start_pos = coords
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"L":  # Line to absolute
				if i + 1 < commands.size():
					current_pos = _parse_coord(commands[i + 1])
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"H":  # Horizontal line
				if i + 1 < commands.size():
					current_pos.x = float(commands[i + 1])
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"V":  # Vertical line
				if i + 1 < commands.size():
					current_pos.y = float(commands[i + 1])
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"h":  # Horizontal line relative
				if i + 1 < commands.size():
					current_pos.x += float(commands[i + 1])
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"v":  # Vertical line relative
				if i + 1 < commands.size():
					current_pos.y += float(commands[i + 1])
					points.append(current_pos)
					i += 2
				else:
					i += 1
			"C":  # Cubic Bezier curve (simplified - just use end point)
				if i + 3 < commands.size():
					# Skip control points, use end point
					current_pos = _parse_coord(commands[i + 3])
					points.append(current_pos)
					i += 4
				else:
					i += 1
			"Z", "z":  # Close path
				points.append(start_pos)
				i += 1
			_:
				# Try to parse as coordinate
				if "," in cmd:
					current_pos = _parse_coord(cmd)
					points.append(current_pos)
				i += 1

	# Draw the path
	if points.size() >= 2:
		if filled:
			draw_colored_polygon(points, color)
		draw_polyline(points, color, config.stroke_width * 0.75)
```
