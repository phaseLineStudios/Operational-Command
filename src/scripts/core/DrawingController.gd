class_name DrawingController
extends Node
## Handles drawing on the map with pens and eraser.
##
## Tracks which drawing tool is held and renders lines when the player
## holds left click. Drawings are session-only and cleared on mission end.

signal drawing_started
signal drawing_updated
signal drawing_cleared

## Drawing tool types
enum Tool { NONE, PEN_BLACK, PEN_BLUE, PEN_RED, ERASER }

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
var _scenario_strokes: Array[Dictionary] = []  # Pre-drawn strokes from scenario
var _last_point: Vector3 = Vector3.ZERO
var _terrain_render: TerrainRender = null  # TerrainRender reference for coordinate conversion

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
		if (
			_current_stroke.is_empty()
			or _last_point.distance_to(world_pos) > point_distance_threshold
		):
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
			_strokes.append({"tool": _current_tool, "points": _current_stroke.duplicate()})

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
					new_strokes.append({"tool": tool, "points": segment})

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
		var is_last := i == surviving_indices.size() - 1
		var has_gap := not is_last and (surviving_indices[i + 1] != idx + 1)

		if is_last or has_gap:
			if current_segment.size() >= 2:
				segments.append(current_segment.duplicate())
			current_segment.clear()

	return segments


func _update_drawing_mesh() -> void:
	var drawing_mesh: MeshInstance3D = map_mesh.get_node_or_null("DrawingMesh")
	if not drawing_mesh:
		LogService.warning("_update_drawing_mesh: drawing_mesh not found", "DrawingController.gd")
		return

	# Create arrays for the mesh
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Draw scenario strokes first (underneath player strokes)
	for stroke in _scenario_strokes:
		var points: Array = stroke.points
		var color: Color = stroke.get("color", Color.BLACK)
		_draw_stroke(surface_tool, points, Tool.NONE, false, color)

	# Draw all completed player strokes
	for stroke in _strokes:
		var tool: Tool = stroke.tool
		var points: Array = stroke.points
		_draw_stroke(surface_tool, points, tool, false)

	# Draw current stroke preview
	if _is_drawing and not _current_stroke.is_empty() and _current_tool != Tool.ERASER:
		_draw_stroke(surface_tool, _current_stroke, _current_tool, true)

	if surface_tool.get_primitive_type() != -1:
		surface_tool.generate_normals()
		var array_mesh := surface_tool.commit()
		drawing_mesh.mesh = array_mesh
	else:
		drawing_mesh.mesh = null


func _draw_stroke(
	surface_tool: SurfaceTool,
	points: Array,
	tool: Tool,
	_is_preview: bool,
	custom_color: Color = Color.BLACK
) -> void:
	if points.size() < 2:
		return

	# Get color based on tool or use custom color
	var color := custom_color if tool == Tool.NONE else _get_tool_color(tool)

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

	# Clear scenario strokes
	_scenario_strokes.clear()

	_update_drawing_mesh()
	drawing_cleared.emit()


## Get total number of strokes drawn
func get_stroke_count() -> int:
	return _strokes.size()


## Load scenario drawings and render them.
## [param scenario] ScenarioData with drawings to render.
## [param terrain_renderer] TerrainRender for coordinate conversion.
func load_scenario_drawings(scenario: ScenarioData, terrain_renderer: TerrainRender) -> void:
	if scenario == null or terrain_renderer == null:
		LogService.warning(
			"load_scenario_drawings: scenario or terrain_renderer is null", "DrawingController.gd"
		)
		return

	_terrain_render = terrain_renderer

	# Clear existing scenario drawings
	_scenario_strokes.clear()

	# Separate stamps and strokes
	var stamps: Array[ScenarioDrawingStamp] = []

	for drawing in scenario.drawings:
		if drawing == null:
			continue

		if drawing is ScenarioDrawingStroke and drawing.visible:
			var stroke := _convert_scenario_stroke(drawing)
			if stroke != null and not stroke.is_empty():
				_scenario_strokes.append(stroke)
			else:
				LogService.warning(
					"Failed to convert stroke %s" % drawing.id, "DrawingController.gd"
				)
		elif drawing is ScenarioDrawingStamp and drawing.visible:
			stamps.append(drawing)

	# Load stamps into 2D StampLayer (rendered in terrain viewport)
	if terrain_renderer.stamp_layer:
		terrain_renderer.stamp_layer.load_stamps(stamps)
	else:
		LogService.warning(
			"Cannot load stamps: terrain_renderer.stamp_layer is null", "DrawingController.gd"
		)

	_update_drawing_mesh()


## Convert a ScenarioDrawingStroke to internal stroke format.
## [param drawing] ScenarioDrawingStroke from scenario.
## [return] Dictionary with tool and points, or null if conversion fails.
func _convert_scenario_stroke(drawing: ScenarioDrawingStroke) -> Dictionary:
	if drawing.points_m.is_empty():
		return {}

	# Convert 2D terrain points to 3D world points
	var world_points: Array[Vector3] = []
	for point_2d in drawing.points_m:
		var world_point: Variant = _terrain_to_world(point_2d)
		if world_point != null:
			world_points.append(world_point)

	if world_points.is_empty():
		return {}

	# Convert color to tool
	var tool := _color_to_tool(drawing.color)

	return {"tool": tool, "points": world_points, "color": drawing.color}


## Convert terrain 2D position to 3D world position on the map.
## [param pos_m] Terrain position in meters.
## [return] World position as Vector3, or null if conversion fails.
func _terrain_to_world(pos_m: Vector2) -> Variant:
	if _terrain_render == null:
		LogService.warning("_terrain_to_world: _terrain_render is null", "DrawingController.gd")
		return null

	if map_mesh == null or map_mesh.mesh == null:
		LogService.warning("_terrain_to_world: map_mesh or mesh is null", "DrawingController.gd")
		return null

	var mesh_size := Vector2.ZERO
	if map_mesh.mesh is PlaneMesh:
		mesh_size = map_mesh.mesh.size
	else:
		LogService.warning(
			"_terrain_to_world: map_mesh.mesh is not PlaneMesh", "DrawingController.gd"
		)
		return null

	if _terrain_render.data == null:
		LogService.warning("_terrain_to_world: terrain_render.data is null", "DrawingController.gd")
		return null

	var terrain_width_m := float(_terrain_render.data.width_m)
	var terrain_height_m := float(_terrain_render.data.height_m)

	if terrain_width_m == 0 or terrain_height_m == 0:
		LogService.warning("_terrain_to_world: terrain dimensions are zero", "DrawingController.gd")
		return null

	# Normalize terrain position to -0.5..0.5 range (mesh local space)
	var normalized_x := (pos_m.x / terrain_width_m) - 0.5
	var normalized_z := (pos_m.y / terrain_height_m) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := map_mesh.to_global(local_pos)

	return world_pos


## Convert color to closest drawing tool.
## [param color] Stroke color.
## [return] Tool enum value.
func _color_to_tool(color: Color) -> Tool:
	# Match to closest tool color
	var r := color.r
	var g := color.g
	var b := color.b

	# Black: low RGB
	if r < 0.3 and g < 0.3 and b < 0.3:
		return Tool.PEN_BLACK

	# Blue: high B, low R
	if b > 0.5 and r < 0.5:
		return Tool.PEN_BLUE

	# Red: high R, low B
	if r > 0.5 and b < 0.5:
		return Tool.PEN_RED

	# Default to black
	return Tool.PEN_BLACK
