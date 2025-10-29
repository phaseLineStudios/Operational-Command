## Military symbol renderer using Godot's CanvasItem drawing
## Draws military symbols using draw_* methods
class_name MilSymbolRenderer
extends Node2D

## Configuration for rendering
var config: MilSymbolConfig

## Symbol properties
var affiliation: MilSymbol.UnitAffiliation = MilSymbol.UnitAffiliation.FRIEND
var domain: MilSymbolGeometry.Domain = MilSymbolGeometry.Domain.GROUND
var icon_type: MilSymbol.UnitType = MilSymbol.UnitType.INFANTRY

## Text modifiers
var unit_size_text: String = ""  # e.g., "II" for company
var unique_designation: String = ""  # e.g., "A/1-5"

## Scale factor to fit symbol into pixel size
var scale_factor: float = 1.0


func _ready() -> void:
	if config == null:
		config = MilSymbolConfig.create_default()
	_calculate_scale()


## Set the symbol to render
func setup_symbol(
	p_affiliation: MilSymbol.UnitAffiliation,
	p_domain: MilSymbolGeometry.Domain,
	p_icon_type: MilSymbol.UnitType,
	p_config: MilSymbolConfig = null
) -> void:
	affiliation = p_affiliation
	domain = p_domain
	icon_type = p_icon_type

	if p_config != null:
		config = p_config

	_calculate_scale()
	queue_redraw()


## Calculate scale factor to fit symbol into configured size
func _calculate_scale() -> void:
	var target_size: float = config.get_pixel_size()
	# Account for resolution scaling - if rendering at higher res, scale up proportionally
	scale_factor = (target_size * config.resolution_scale) / MilSymbolConfig.BASE_SIZE


## Draw the complete symbol
func _draw() -> void:
	if config == null:
		return

	# Apply scale transformation
	var transform_mat := Transform2D()
	transform_mat = transform_mat.scaled(Vector2(scale_factor, scale_factor))

	# Draw with transformation
	draw_set_transform_matrix(transform_mat)

	# Draw frame
	if config.framed:
		_draw_frame()

	# Draw icon
	if config.show_icon:
		_draw_icon()

	# Draw size/echelon indicator
	if unit_size_text != "":
		_draw_size_indicator()

	# Draw unique designation
	if unique_designation != "":
		_draw_unique_designation()

	# Reset transform
	draw_set_transform_matrix(Transform2D())


## Draw the base frame geometry
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


## Draw the unit icon
func _draw_icon() -> void:
	var icon_data := MilSymbolIcons.get_icon(icon_type, affiliation)
	if icon_data.is_empty():
		return

	var icon_col := config.icon_color

	match icon_data.get("type", ""):
		"lines":
			_draw_icon_lines(icon_data.get("paths", []), icon_col)
		"path":
			_draw_icon_path(icon_data.get("d", ""), icon_col, icon_data.get("filled", false))
		"circle":
			var center: Vector2 = icon_data.get("center", Vector2(100, 100))
			var radius: float = icon_data.get("radius", 10.0)
			var filled: bool = icon_data.get("filled", false)
			if filled:
				draw_circle(center, radius, icon_col)
			else:
				draw_arc(center, radius, 0, TAU, 32, icon_col, config.stroke_width * 0.75)
		"ellipse":
			var center: Vector2 = icon_data.get("center", Vector2(100, 100))
			var rx: float = icon_data.get("rx", 20.0)
			var ry: float = icon_data.get("ry", 10.0)
			var filled: bool = icon_data.get("filled", false)
			_draw_ellipse(center, rx, ry, icon_col, filled)
		"shapes":
			_draw_icon_shapes(icon_data.get("shapes", []), icon_col)
		"mixed":
			_draw_icon_shapes(icon_data.get("shapes", []), icon_col)
			_draw_icon_lines(icon_data.get("paths", []), icon_col)
		"text":
			_draw_icon_text(
				icon_data.get("text", ""),
				icon_data.get("position", Vector2(100, 100)),
				icon_data.get("size", 32),
				icon_col
			)


## Draw icon as lines
func _draw_icon_lines(paths: Array, color: Color) -> void:
	for path in paths:
		if path is Array and path.size() >= 2:
			draw_polyline(path, color, config.stroke_width * 0.75)


## Draw icon from SVG path data
## Supports basic SVG path commands: M, L, H, V, C, Z
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


## Parse coordinate from string "x,y"
func _parse_coord(coord_str: String) -> Vector2:
	var parts := coord_str.split(",")
	if parts.size() >= 2:
		return Vector2(float(parts[0]), float(parts[1]))
	return Vector2.ZERO


## Draw icon as shapes
func _draw_icon_shapes(shapes: Array, color: Color) -> void:
	for shape_data in shapes:
		if not shape_data is Dictionary:
			continue

		var shape_type: String = shape_data.get("shape", "")
		var filled: bool = shape_data.get("filled", false)

		match shape_type:
			"circle":
				var center: Vector2 = shape_data.get("center", Vector2.ZERO)
				var radius: float = shape_data.get("radius", 10.0)
				if filled:
					draw_circle(center, radius, color)
				else:
					draw_arc(center, radius, 0, TAU, 32, color, config.stroke_width * 0.75)
			"rect":
				var rect: Rect2 = shape_data.get("rect", Rect2(0, 0, 10, 10))
				var r: float = float(shape_data.get("corner_radius", shape_data.get("radius", 0.0)))
				var segs: int = int(shape_data.get("segments", 10))
				if r > 0.0:
					_draw_rounded_rect(rect, r, color, filled, config.stroke_width * 0.75, segs)
				else:
					if filled:
						draw_rect(rect, color)
					else:
						draw_rect(rect, color, false, config.stroke_width * 0.75)
			"oval":
				var rect: Rect2 = shape_data.get("rect", Rect2(0, 0, 20, 10))
				_draw_oval(rect, color, filled)


## Draw an oval (ellipse) from rect
func _draw_oval(rect: Rect2, color: Color, filled: bool) -> void:
	var center := rect.get_center()
	var rx := rect.size.x / 2.0
	var ry := rect.size.y / 2.0
	var segments := 32

	var points: PackedVector2Array = PackedVector2Array()

	for i in range(segments + 1):
		var angle := (TAU * i) / segments
		var x := center.x + rx * cos(angle)
		var y := center.y + ry * sin(angle)
		points.append(Vector2(x, y))

	if filled:
		draw_colored_polygon(points, color)
	else:
		draw_polyline(points, color, config.stroke_width * 0.75)


## Draw an ellipse with center and radii
func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color, filled: bool) -> void:
	var segments := 64
	var points: PackedVector2Array = PackedVector2Array()

	for i in range(segments + 1):
		var angle := (TAU * i) / segments
		var x := center.x + rx * cos(angle)
		var y := center.y + ry * sin(angle)
		points.append(Vector2(x, y))

	if filled:
		draw_colored_polygon(points, color)
	else:
		draw_polyline(points, color, config.stroke_width * 0.75)


## Draw icon text
func _draw_icon_text(text: String, pos: Vector2, size: int, color: Color) -> void:
	# Note: For proper text rendering, you'd want to use a Font resource
	# For now, we'll use draw_string with default font
	var font_size := int(size * scale_factor)
	draw_string(
		ThemeDB.fallback_font,
		pos - Vector2(size * 0.5, -size * 0.25),
		text,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		font_size,
		color
	)


## Draw size/echelon indicator above the frame
func _draw_size_indicator() -> void:
	var bounds := MilSymbolGeometry.get_frame_bounds(domain, affiliation)
	var pos := Vector2(bounds.position.x, bounds.position.y - 10)

	var font_size := int(config.font_size * 0.8)
	draw_string(
		ThemeDB.fallback_font,
		pos,
		unit_size_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		bounds.size.x,
		font_size,
		config.text_color
	)


## Draw unique designation below the frame
func _draw_unique_designation() -> void:
	var bounds := MilSymbolGeometry.get_frame_bounds(domain, affiliation)
	var pos := Vector2(
		bounds.position.x + bounds.size.x / 2, bounds.position.y + bounds.size.y + 20
	)

	var font_size := int(config.font_size * 0.6)
	draw_string(
		ThemeDB.fallback_font,
		pos,
		unique_designation,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		font_size,
		config.text_color
	)

## Draw a rounded rectangle.
## [param rect] Rect region in px.
## [param radius] Corner radius in px (clamped to half of min(width, height)).
## [param color] Fill/line color.
## [param filled] If true, fills; otherwise draws outline.
## [param width] Outline width in px (used when !filled).
## [param segments] Segments per corner arc (>= 2 recommended).
func _draw_rounded_rect(
	rect: Rect2,
	radius: float,
	color: Color,
	filled: bool,
	width: float,
	segments: int = 10
) -> void:
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	var r := clampf(radius, 0.0, min(w, h) * 0.5)

	if r <= 0.0:
		if filled:
			draw_rect(rect, color)
		else:
			draw_rect(rect, color, false, width)
		return

	if filled:
		# Middle column
		if w - 2.0 * r > 0.0:
			draw_rect(Rect2(x + r, y, w - 2.0 * r, h), color)
		# Left/right vertical strips
		if h - 2.0 * r > 0.0:
			draw_rect(Rect2(x,         y + r, r, h - 2.0 * r), color)
			draw_rect(Rect2(x + w - r, y + r, r, h - 2.0 * r), color)
		# Quarter-circle fills
		_fill_arc_fan(Vector2(x + r,     y + r),     r, PI,        PI * 1.5, color, segments) # TL
		_fill_arc_fan(Vector2(x + w - r, y + r),     r, -PI * 0.5, 0.0,       color, segments) # TR
		_fill_arc_fan(Vector2(x + w - r, y + h - r), r, 0.0,       PI * 0.5,  color, segments) # BR
		_fill_arc_fan(Vector2(x + r,     y + h - r), r, PI * 0.5,  PI,        color, segments) # BL
	else:
		# Straight edges
		draw_line(Vector2(x + r,     y),         Vector2(x + w - r, y),         color, width)
		draw_line(Vector2(x + w,     y + r),     Vector2(x + w,     y + h - r), color, width)
		draw_line(Vector2(x + w - r, y + h),     Vector2(x + r,     y + h),     color, width)
		draw_line(Vector2(x,         y + h - r), Vector2(x,         y + r),     color, width)
		# Corner arcs
		draw_arc(Vector2(x + w - r, y + r),     r, -PI * 0.5, 0.0,       segments, color, width) # TR
		draw_arc(Vector2(x + w - r, y + h - r), r, 0.0,       PI * 0.5,  segments, color, width) # BR
		draw_arc(Vector2(x + r,     y + h - r), r, PI * 0.5,  PI,        segments, color, width) # BL
		draw_arc(Vector2(x + r,     y + r),     r, PI,        PI * 1.5,  segments, color, width) # TL
		

## Fill a quarter circle with a triangle fan.
## [param center] Arc center.
## [param r] Radius.
## [param a0] Start angle (rad).
## [param a1] End angle (rad).
## [param color] Fill color.
## [param segments] Arc smoothness (>=2).
func _fill_arc_fan(center: Vector2, r: float, a0: float, a1: float, color: Color, segments: int) -> void:
	var seg: int = max(2, segments)
	var pts := PackedVector2Array()
	pts.append(center)
	for i in range(seg + 1):
		var t := float(i) / float(seg)
		var a := lerpf(a0, a1, t)
		pts.append(center + Vector2(cos(a), sin(a)) * r)
	draw_colored_polygon(pts, color)
