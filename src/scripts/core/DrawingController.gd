class_name DrawingController
extends Node
## Handles drawing on the map with pens and eraser.
##
## Tracks which drawing tool is held and renders lines when the player
## holds left click. Drawings are session-only and cleared on mission end.

signal drawing_started()
signal drawing_updated()
signal drawing_cleared()

## Drawing tool types
enum Tool {
	NONE,
	PEN_BLACK,
	PEN_BLUE,
	PEN_RED,
	ERASER
}

## Line width for drawing in world units
@export var line_width: float = 0.001
## Line width for eraser in world units
@export var eraser_width: float = 0.015
## Distance threshold to create new point (prevents too many points)
@export var point_distance_threshold: float = 0.001

## MeshInstance3D of map.
var map_mesh: MeshInstance3D:
	set(value):
		map_mesh = value
		if map_mesh:
			_init_drawing_mesh()

var _current_tool: Tool = Tool.NONE
var _is_drawing: bool = false
var _current_stroke: Array[Vector3] = []
var _strokes: Array[Dictionary] = []  # {tool: Tool, points: Array[Vector3]}
var _last_point: Vector3 = Vector3.ZERO

@onready var camera: Camera3D = %CameraController/CameraBounds/Camera
@onready var interaction: InteractionController = %ObjectController


func _init_drawing_mesh() -> void:
	if not map_mesh or not is_instance_valid(map_mesh):
		LogService.error("Cannot init drawing mesh: map_mesh invalid", "DrawingController")
		return

	# Check if DrawingMesh already exists
	var existing := map_mesh.get_node_or_null("DrawingMesh")
	if existing:
		return

	# Create a MeshInstance3D for rendering drawings
	var drawing_mesh := MeshInstance3D.new()
	drawing_mesh.name = "DrawingMesh"

	# Create an unshaded material that uses vertex colors
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color.WHITE
	material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Disable backface culling
	material.no_depth_test = false
	drawing_mesh.material_override = material
	drawing_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	map_mesh.add_child(drawing_mesh)


func _process(_delta: float) -> void:
	# Update current tool based on what's held
	_update_current_tool()

	if not _is_drawing:
		return

	if _current_tool == Tool.NONE:
		return

	# Project mouse to map plane and add point to current stroke
	var mouse_pos := get_viewport().get_mouse_position()
	var world_pos: Variant = _project_mouse_to_map(mouse_pos)

	if world_pos != null:
		# Only add point if it's far enough from the last point
		if _current_stroke.is_empty() or _last_point.distance_to(world_pos) > point_distance_threshold:
			_current_stroke.append(world_pos)
			_last_point = world_pos

			# If erasing, erase in real-time as we drag
			if _current_tool == Tool.ERASER:
				_erase_at_point(world_pos)

			_update_drawing_mesh()


func _update_current_tool() -> void:
	if not interaction or not interaction._held:
		_current_tool = Tool.NONE
		return

	# Detect tool based on the name of the held object
	var held_name := interaction._held.name

	match held_name:
		"PenBlack":
			_current_tool = Tool.PEN_BLACK
		"PenBlue":
			_current_tool = Tool.PEN_BLUE
		"PenRed":
			_current_tool = Tool.PEN_RED
		"Eraser":
			_current_tool = Tool.ERASER
		_:
			_current_tool = Tool.NONE


func _input(event: InputEvent) -> void:
	if _current_tool == Tool.NONE:
		return

	if interaction and interaction._held and interaction._held.is_inspecting():
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drawing()
		else:
			_end_drawing()


func _start_drawing() -> void:
	_is_drawing = true
	_current_stroke.clear()
	_last_point = Vector3.ZERO
	drawing_started.emit()


func _end_drawing() -> void:
	if _is_drawing and not _current_stroke.is_empty():
		if _current_tool != Tool.ERASER:
			_strokes.append({
				"tool": _current_tool,
				"points": _current_stroke.duplicate()
			})

	_current_stroke.clear()
	_is_drawing = false
	_update_drawing_mesh()
	drawing_updated.emit()


## Erase strokes at a single point
func _erase_at_point(erase_point: Vector3) -> void:
	var new_strokes: Array[Dictionary] = []

	for stroke in _strokes:
		var stroke_points: Array = stroke.points
		var tool: Tool = stroke.tool
		var surviving_points: Array[Vector3] = []

		for stroke_point in stroke_points:
			if stroke_point.distance_to(erase_point) >= eraser_width:
				surviving_points.append(stroke_point)

		if surviving_points.size() > 0:
			var segments := _split_into_segments(surviving_points, stroke_points)
			for segment in segments:
				if segment.size() >= 2:
					new_strokes.append({
						"tool": tool,
						"points": segment
					})

	_strokes = new_strokes


## Split points into continuous segments by detecting gaps in the original sequence
func _split_into_segments(surviving_points: Array[Vector3], original_points: Array) -> Array:
	var segments: Array = []
	var current_segment: Array[Vector3] = []

	# Build index map of surviving points
	var surviving_indices: Array[int] = []
	for surv_point in surviving_points:
		for i in range(original_points.size()):
			if original_points[i] == surv_point:
				surviving_indices.append(i)
				break

	# Split into segments where indices are not consecutive
	for i in range(surviving_indices.size()):
		var idx := surviving_indices[i]
		current_segment.append(original_points[idx])

		# Check if next index is not consecutive (gap detected)
		var is_last := (i == surviving_indices.size() - 1)
		var has_gap := not is_last and (surviving_indices[i + 1] != idx + 1)

		if is_last or has_gap:
			if current_segment.size() >= 2:
				segments.append(current_segment.duplicate())
			current_segment.clear()

	return segments


func _update_drawing_mesh() -> void:
	var drawing_mesh: MeshInstance3D = map_mesh.get_node_or_null("DrawingMesh")
	if not drawing_mesh:
		return

	# Create arrays for the mesh
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Draw all completed strokes
	for stroke in _strokes:
		var tool: Tool = stroke.tool
		var points: Array = stroke.points
		_draw_stroke(surface_tool, points, tool, false)

	if _is_drawing and not _current_stroke.is_empty() and _current_tool != Tool.ERASER:
		_draw_stroke(surface_tool, _current_stroke, _current_tool, true)

	if surface_tool.get_primitive_type() != -1:
		surface_tool.generate_normals()
		var array_mesh := surface_tool.commit()
		drawing_mesh.mesh = array_mesh
	else:
		drawing_mesh.mesh = null


func _draw_stroke(surface_tool: SurfaceTool, points: Array, tool: Tool, _is_preview: bool) -> void:
	if points.size() < 2:
		return

	# Get color based on tool
	var color := _get_tool_color(tool)

	# Get width based on tool
	var width := line_width if tool != Tool.ERASER else eraser_width

	# Convert world points to map-local space
	var local_points: Array[Vector3] = []
	for point in points:
		var local_point := map_mesh.to_local(point)
		# Offset above the map surface to prevent z-fighting
		local_point.y += 0.001
		local_points.append(local_point)

	for i in range(local_points.size() - 1):
		var p1: Vector3 = local_points[i]
		var p2: Vector3 = local_points[i + 1]

		# Calculate perpendicular direction for line width
		var dir := (p2 - p1).normalized()
		var perp := Vector3(-dir.z, 0, dir.x) * width * 0.5

		# Create quad (two triangles) for this line segment
		var v1 := p1 - perp
		var v2 := p1 + perp
		var v3 := p2 + perp
		var v4 := p2 - perp

		# First triangle
		surface_tool.set_color(color)
		surface_tool.add_vertex(v1)
		surface_tool.set_color(color)
		surface_tool.add_vertex(v2)
		surface_tool.set_color(color)
		surface_tool.add_vertex(v3)

		# Second triangle
		surface_tool.set_color(color)
		surface_tool.add_vertex(v1)
		surface_tool.set_color(color)
		surface_tool.add_vertex(v3)
		surface_tool.set_color(color)
		surface_tool.add_vertex(v4)



func _get_tool_color(tool: Tool) -> Color:
	match tool:
		Tool.PEN_BLACK:
			return Color.BLACK
		Tool.PEN_BLUE:
			return Color.BLUE
		Tool.PEN_RED:
			return Color.RED
		Tool.ERASER:
			return Color.WHITE
		_:
			return Color.BLACK


func _project_mouse_to_map(mouse_pos: Vector2) -> Variant:
	if not camera or not is_instance_valid(camera):
		return null

	if not map_mesh or not is_instance_valid(map_mesh):
		return null

	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)

	# Get the map plane in world space
	var map_transform := map_mesh.global_transform
	var plane_point := map_transform.origin
	var plane_normal := (map_transform.basis * Vector3.UP).normalized()

	# Ray-plane intersection
	var denom := plane_normal.dot(dir)
	if is_equal_approx(denom, 0.0):
		return null

	var t := plane_normal.dot(plane_point - from) / denom
	if t < 0.0:
		return null

	var hit_point := from + dir * t
	return hit_point


## Set the current drawing tool
func set_tool(tool: Tool) -> void:
	_current_tool = tool


## Get the current drawing tool
func get_tool() -> Tool:
	return _current_tool


## Check if any drawing has been made
func has_drawing() -> bool:
	return not _strokes.is_empty()


## Clear all drawings
func clear_all() -> void:
	_strokes.clear()
	_current_stroke.clear()
	_is_drawing = false
	_update_drawing_mesh()
	drawing_cleared.emit()


## Get total number of strokes drawn
func get_stroke_count() -> int:
	return _strokes.size()
