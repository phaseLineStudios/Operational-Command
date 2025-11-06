extends Control
## Tool for drawing unit symbols and generating GDScript code using shapes.
##
## Place and edit shapes, then click "Generate Code"
## to get the GDScript code to paste into UnitSymbolGenerator.

## Shape types
enum ShapeType {
	LINE,
	CIRCLE,
	ELLIPSE,
	RECTANGLE,
}

## Canvas dimensions (larger for easier editing)
const CANVAS_SIZE := 384
const ICON_AREA := 144.0  # 3x scale of actual (48 * 3)

## Drawing state
var _shapes: Array[Shape] = []
var _current_shape: Shape = null
var _selected_shape: Shape = null
var _is_placing := false
var _is_dragging := false
var _drag_start: Vector2
var _current_tool := ShapeType.LINE
var _current_filled := false
var _current_corner_radius := 0.0

@onready var canvas: Control = %Canvas
@onready var code_output: TextEdit = %CodeOutput
@onready var clear_btn: Button = %ClearButton
@onready var generate_btn: Button = %GenerateButton
@onready var copy_btn: Button = %CopyButton
@onready var delete_btn: Button = %DeleteButton

@onready var line_btn: Button = %LineButton
@onready var circle_btn: Button = %CircleButton
@onready var ellipse_btn: Button = %EllipseButton
@onready var rect_btn: Button = %RectButton

@onready var filled_check: CheckBox = %FilledCheck
@onready var corner_slider: HSlider = %CornerRadiusSlider
@onready var corner_label: Label = %CornerRadiusLabel


func _ready() -> void:
	clear_btn.pressed.connect(_on_clear_pressed)
	generate_btn.pressed.connect(_on_generate_pressed)
	copy_btn.pressed.connect(_on_copy_pressed)
	delete_btn.pressed.connect(_on_delete_pressed)

	line_btn.pressed.connect(func(): _set_tool(ShapeType.LINE))
	circle_btn.pressed.connect(func(): _set_tool(ShapeType.CIRCLE))
	ellipse_btn.pressed.connect(func(): _set_tool(ShapeType.ELLIPSE))
	rect_btn.pressed.connect(func(): _set_tool(ShapeType.RECTANGLE))

	filled_check.toggled.connect(func(value): _current_filled = value)
	corner_slider.value_changed.connect(_on_corner_radius_changed)

	canvas.draw.connect(_on_canvas_draw)
	_set_tool(ShapeType.LINE)


## Set current drawing tool
func _set_tool(tool: ShapeType) -> void:
	_current_tool = tool
	_selected_shape = null

	# Update button states
	line_btn.button_pressed = (tool == ShapeType.LINE)
	circle_btn.button_pressed = (tool == ShapeType.CIRCLE)
	ellipse_btn.button_pressed = (tool == ShapeType.ELLIPSE)
	rect_btn.button_pressed = (tool == ShapeType.RECTANGLE)

	# Show/hide corner radius for rectangles
	corner_slider.visible = (tool == ShapeType.RECTANGLE)
	corner_label.visible = (tool == ShapeType.RECTANGLE)

	canvas.queue_redraw()


## Handle corner radius slider
func _on_corner_radius_changed(value: float) -> void:
	_current_corner_radius = value
	corner_label.text = "Corner Radius: %.1f" % value


## Handle mouse input for placing/editing shapes
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var local_pos := canvas.get_local_mouse_position()
			if _is_point_in_canvas(local_pos):
				if event.pressed:
					_start_placement(local_pos)
				else:
					_end_placement()
				get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		var local_pos := canvas.get_local_mouse_position()
		if _is_placing and _is_point_in_canvas(local_pos):
			_update_placement(local_pos)
			canvas.queue_redraw()


## Check if point is within canvas bounds
func _is_point_in_canvas(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < CANVAS_SIZE and pos.y >= 0 and pos.y < CANVAS_SIZE


## Start placing a new shape
func _start_placement(pos: Vector2) -> void:
	# Check if clicking on existing shape to select it
	for shape in _shapes:
		if shape.is_point_near(pos):
			_selected_shape = shape
			_is_dragging = true
			_drag_start = pos
			canvas.queue_redraw()
			return

	# Start new shape
	_selected_shape = null
	_is_placing = true
	_current_shape = Shape.new(_current_tool, pos, pos, _current_filled, _current_corner_radius)


## Update shape being placed
func _update_placement(pos: Vector2) -> void:
	if _current_shape:
		_current_shape.end = pos


## End shape placement
func _end_placement() -> void:
	if _is_placing and _current_shape:
		# Only add if shape has some size
		var bounds := _current_shape.get_bounds()
		if bounds.size.length() > 5.0:
			_shapes.append(_current_shape)
		_current_shape = null
		canvas.queue_redraw()

	_is_placing = false
	_is_dragging = false


## Draw canvas with grid, shapes, and guides
func _on_canvas_draw() -> void:
	# Draw background
	canvas.draw_rect(Rect2(0, 0, CANVAS_SIZE, CANVAS_SIZE), Color(0.95, 0.95, 0.95))

	# Draw grid
	var grid_color := Color(0.8, 0.8, 0.8, 0.5)
	for i in range(0, CANVAS_SIZE + 1, 24):
		canvas.draw_line(Vector2(i, 0), Vector2(i, CANVAS_SIZE), grid_color, 1.0)
		canvas.draw_line(Vector2(0, i), Vector2(CANVAS_SIZE, i), grid_color, 1.0)

	# Draw center crosshair
	var center := Vector2(CANVAS_SIZE / 2.0, CANVAS_SIZE / 2.0)
	canvas.draw_line(Vector2(center.x, 0), Vector2(center.x, CANVAS_SIZE), Color.RED, 1.5, true)
	canvas.draw_line(Vector2(0, center.y), Vector2(CANVAS_SIZE, center.y), Color.RED, 1.5, true)

	# Draw icon area boundary
	var half_icon := ICON_AREA / 2.0
	canvas.draw_rect(
		Rect2(center.x - half_icon, center.y - half_icon, ICON_AREA, ICON_AREA),
		Color(0.5, 0.8, 1.0, 0.15),
		true
	)
	canvas.draw_rect(
		Rect2(center.x - half_icon, center.y - half_icon, ICON_AREA, ICON_AREA),
		Color(0.3, 0.6, 1.0, 0.6),
		false,
		2.0
	)

	# Draw all completed shapes
	for shape in _shapes:
		var is_selected := shape == _selected_shape
		_draw_shape(shape, is_selected)

	# Draw current shape being placed
	if _is_placing and _current_shape:
		_draw_shape(_current_shape, false, true)


## Draw a single shape
func _draw_shape(shape: Shape, selected: bool, preview := false) -> void:
	var color := Color.BLACK if not preview else Color(0.4, 0.4, 0.4, 0.7)
	var thickness := 3.0 if not selected else 4.0

	match shape.type:
		ShapeType.LINE:
			canvas.draw_line(shape.start, shape.end, color, thickness, true)

		ShapeType.CIRCLE:
			var center := (shape.start + shape.end) / 2.0
			var radius := shape.start.distance_to(shape.end) / 2.0
			if shape.filled:
				_draw_filled_circle_on_canvas(center, radius, color)
			else:
				_draw_circle_outline_on_canvas(center, radius, color, thickness)

		ShapeType.ELLIPSE:
			var center := (shape.start + shape.end) / 2.0
			var rx: float = abs(shape.end.x - shape.start.x) / 2.0
			var ry: float = abs(shape.end.y - shape.start.y) / 2.0
			if shape.filled:
				_draw_filled_ellipse_on_canvas(center, rx, ry, color)
			else:
				_draw_ellipse_outline_on_canvas(center, rx, ry, color, thickness)

		ShapeType.RECTANGLE:
			var rect := shape.get_bounds()
			if shape.corner_radius > 0:
				_draw_rounded_rect_on_canvas(
					rect, shape.corner_radius, color, shape.filled, thickness
				)
			else:
				if shape.filled:
					canvas.draw_rect(rect, color, true)
				else:
					canvas.draw_rect(rect, color, false, thickness)

	# Draw selection handles
	if selected:
		var handle_color := Color(0.2, 0.7, 1.0)
		canvas.draw_circle(shape.start, 4.0, handle_color)
		canvas.draw_circle(shape.end, 4.0, handle_color)


## Draw filled circle on canvas
func _draw_filled_circle_on_canvas(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for angle_deg in range(0, 360, 5):
		var angle := deg_to_rad(angle_deg)
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	if points.size() > 0:
		canvas.draw_colored_polygon(points, color)


## Draw circle outline on canvas
func _draw_circle_outline_on_canvas(
	center: Vector2, radius: float, color: Color, thickness: float
) -> void:
	var steps := 64
	for i in range(steps):
		var angle1 := (float(i) / steps) * TAU
		var angle2 := (float(i + 1) / steps) * TAU
		var p1 := center + Vector2(cos(angle1), sin(angle1)) * radius
		var p2 := center + Vector2(cos(angle2), sin(angle2)) * radius
		canvas.draw_line(p1, p2, color, thickness, true)


## Draw filled ellipse on canvas
func _draw_filled_ellipse_on_canvas(center: Vector2, rx: float, ry: float, color: Color) -> void:
	var points := PackedVector2Array()
	for angle_deg in range(0, 360, 5):
		var angle := deg_to_rad(angle_deg)
		points.append(center + Vector2(cos(angle) * rx, sin(angle) * ry))
	if points.size() > 0:
		canvas.draw_colored_polygon(points, color)


## Draw ellipse outline on canvas
func _draw_ellipse_outline_on_canvas(
	center: Vector2, rx: float, ry: float, color: Color, thickness: float
) -> void:
	var steps := 64
	for i in range(steps):
		var angle1 := (float(i) / steps) * TAU
		var angle2 := (float(i + 1) / steps) * TAU
		var p1 := center + Vector2(cos(angle1) * rx, sin(angle1) * ry)
		var p2 := center + Vector2(cos(angle2) * rx, sin(angle2) * ry)
		canvas.draw_line(p1, p2, color, thickness, true)


## Draw rounded rectangle on canvas
func _draw_rounded_rect_on_canvas(
	rect: Rect2, _radius: float, color: Color, filled: bool, thickness: float
) -> void:
	# Simplified rounded rect (just draw normal rect for now)
	# Full implementation would need arc drawing
	if filled:
		canvas.draw_rect(rect, color, true)
	else:
		canvas.draw_rect(rect, color, false, thickness)


## Clear all shapes
func _on_clear_pressed() -> void:
	_shapes.clear()
	_current_shape = null
	_selected_shape = null
	_is_placing = false
	canvas.queue_redraw()
	code_output.text = ""


## Delete selected shape
func _on_delete_pressed() -> void:
	if _selected_shape:
		_shapes.erase(_selected_shape)
		_selected_shape = null
		canvas.queue_redraw()


## Generate GDScript code from shapes
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


## Convert canvas point to normalized offset from center
func _point_to_normalized(point: Vector2, canvas_center: Vector2) -> Vector2:
	var offset := point - canvas_center
	# Scale to icon size
	return offset / (ICON_AREA / 2.0)


## Format offset as string with sign
func _format_offset(value: float) -> String:
	if abs(value) < 0.01:
		return ""
	elif value > 0:
		return "+ half * %.2f" % value
	else:
		return "- half * %.2f" % abs(value)


## Copy generated code to clipboard
func _on_copy_pressed() -> void:
	if code_output.text != "":
		DisplayServer.clipboard_set(code_output.text)
		print("Code copied to clipboard!")


## Shape data structure
class Shape:
	var type: ShapeType
	var start: Vector2
	var end: Vector2
	var filled: bool
	var corner_radius: float

	func _init(
		p_type: ShapeType, p_start: Vector2, p_end: Vector2, p_filled := false, p_radius := 0.0
	):
		type = p_type
		start = p_start
		end = p_end
		filled = p_filled
		corner_radius = p_radius

	func get_bounds() -> Rect2:
		var min_x: float = min(start.x, end.x)
		var max_x: float = max(start.x, end.x)
		var min_y: float = min(start.y, end.y)
		var max_y: float = max(start.y, end.y)
		return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)

	func is_point_near(pos: Vector2, threshold := 8.0) -> bool:
		var bounds := get_bounds()
		return bounds.grow(threshold).has_point(pos)
