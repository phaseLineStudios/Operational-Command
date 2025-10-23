class_name TerrainRender
extends Control

## Renders map: grid, margins, contours, surfaces, features, labels

## Emits when the map is resized
signal map_resize

## Grid cell size in meters
const GRID_SIZE_M = 100

## Terrain Data
@export var data: TerrainData:
	set = _set_data

## Visual Style
@export_group("Terrain Base")
## Base background map color
@export var base_color: Color = Color(1.0, 1.0, 1.0)
## Color of the map border
@export var terrain_border_color: Color = Color(0.0, 0.0, 0.0)
## Width of the map border
@export var terrain_border_px: int = 1

@export_group("Margin")
## Font size for map title
@export var title_size: int = 24
## Color of outer margin
@export var margin_color: Color = Color(1.0, 1.0, 1.0)
## Size of outer margin top
@export var margin_top_px: int = 50
## Size of outer margin bottom
@export var margin_bottom_px: int = 50
## Size of outer margin left
@export var margin_left_px: int = 50
## Size of outer margin right
@export var margin_right_px: int = 50
## Color for text
@export var label_color: Color = Color(0.05, 0.05, 0.05, 1.0)
## Font for text
@export var label_font: Font
## Font size of grid number text
@export var label_size: int = 14

@export_group("Grid")
## Color of grid lines for every 100m
@export var grid_100m_color: Color = Color(0.2, 0.2, 0.2, 0.25)
## Color of grid lines for every 1000m
@export var grid_1km_color: Color = Color(0.1, 0.1, 0.1, 0.5)
## Width of grid lines for every 100m
@export var grid_line_px: float = 1.0
## Width of grid lines for every 1000m
@export var grid_1km_line_px: float = 2.0

@export_group("Contours")
## Base contour color
@export var contour_color: Color = Color(0.15, 0.15, 0.15, 0.7)
## Contour color for thick lines
@export var contour_thick_color: Color = Color(0.1, 0.1, 0.1, 0.85)
## Base width for contour lines
@export var contour_px: float = 1.0
## How often should contour lines be thick (in m)
@export var contour_thick_every_m: int = 50
## Smoothing iterations
@export var smooth_iterations: int = 2
## Smoothing segment lengths
@export var smooth_segment_len_m: float = 4.0
## Should smoothing keep ends
@export var smooth_keep_ends: bool = true
## Contour label spacing
@export var contour_label_every_m: int = 200
## Only show elevation label on thick contours
@export var contour_label_on_thick_only: bool = true
## Contour label color
@export var contour_label_color: Color = Color(0.1, 0.1, 0.1, 0.95)
## Contour label background
@export var contour_label_bg: Color = Color(1, 1, 1, 0.85)
## Contour label padding
@export var contour_label_padding_px: float = 3.0
## Contour label font
@export var contour_label_font: Font
## Contour label font size
@export var contour_label_size: int = 12
## Extra space beyond plaque width
@export var contour_label_gap_extra_px: float = 2.0

@export_group("Navigation")
## reference to the PathGrid used for movement/pathfinding.
@export var path_grid: PathGrid
## If true, rebuild the grid automatically when data is set/changed.
@export var nav_auto_build := true
## Default profile to rebuild for when auto-building.
@export var nav_default_profile: int = TerrainBrush.MoveProfile.FOOT

@export_group("Performance")
## Cell size (m) for surface spatial index grid.
@export var surface_index_cell_m: int = 200

var _base_sb: StyleBoxFlat
var _debounce_timer: SceneTreeTimer
var _surface_index: Dictionary = {}
var _surface_meta: Array = []

@onready var margin: PanelContainer = %MapMargin
@onready var base_layer: PanelContainer = %TerrainBase
@onready var surface_layer: SurfaceLayer = %SurfaceLayer
@onready var line_layer: LineLayer = %LineLayer
@onready var point_layer: PointLayer = %PointLayer
@onready var contour_layer: ContourLayer = %ContourLayer
@onready var grid_layer: GridLayer = %GridLayer
@onready var label_layer: LabelLayer = %LabelLayer
@onready var error_layer: CenterContainer = %ErrorLayer
@onready var error_label: Label = %ErrorLayer/ErrorLabel


func _ready():
	_apply_base_style_if_needed()
	_draw_map_size()
	base_layer.resized.connect(_on_base_layer_resize)

	if not data:
		render_error("NO TERRAIN DATA")

	if data and path_grid:
		path_grid.data = data
		if nav_auto_build:
			path_grid.rebuild(nav_default_profile)


## Build base style
func _apply_base_style_if_needed() -> void:
	if _base_sb == null:
		_base_sb = StyleBoxFlat.new()
	_base_sb.bg_color = base_color
	_base_sb.set_border_width_all(terrain_border_px)
	_base_sb.border_color = terrain_border_color
	base_layer.add_theme_stylebox_override("panel", _base_sb)


## Set new Terrain Data
func _set_data(d: TerrainData):
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		clear_render_error()
		if path_grid:
			path_grid.data = data
			if nav_auto_build:
				path_grid.rebuild(nav_default_profile)
	else:
		render_error("NO TERRAIN DATA")
	call_deferred("_draw_map_size")
	call_deferred("_push_data_to_layers")
	call_deferred("_mark_all_dirty")


## Push exports to their respective layers
func _push_data_to_layers() -> void:
	if grid_layer:
		grid_layer.set_data(data)
		grid_layer.apply_style(self)

	if margin:
		margin.set_data(data)
		margin.apply_style(self)

	if contour_layer:
		contour_layer.set_data(data)
		contour_layer.apply_style(self)

	if surface_layer:
		surface_layer.set_data(data)

	if line_layer:
		line_layer.set_data(data)

	if point_layer:
		point_layer.set_data(data)

	if label_layer:
		label_layer.set_data(data)
		label_layer.apply_style(self)


## Reconfigure if terrain data is changed
func _on_data_changed() -> void:
	_debounce_relayout_and_push()
	if path_grid and nav_auto_build:
		path_grid.rebuild(nav_default_profile)


## Show a render error
func render_error(error: String = "") -> void:
	if error_layer == null:
		return
	error_layer.visible = true
	error_label.text = error


## Hide the render error
func clear_render_error() -> void:
	if error_layer == null:
		return
	error_layer.visible = false


## Mark elements as dirty to redraw
func _mark_all_dirty() -> void:
	if grid_layer:
		grid_layer.mark_dirty()
	if margin:
		margin.mark_dirty()
	if contour_layer:
		contour_layer.mark_dirty()
	if surface_layer:
		surface_layer.mark_dirty()
	if line_layer:
		line_layer.mark_dirty()
	if point_layer:
		point_layer.mark_dirty()
	if label_layer:
		label_layer.mark_dirty()
	queue_redraw()


## Debounce the relayout and push styles
func _debounce_relayout_and_push() -> void:
	if _debounce_timer:
		return
	_debounce_timer = get_tree().create_timer(0.03)
	_debounce_timer.timeout.connect(
		func():
			_debounce_timer = null
			_draw_map_size()
			_push_data_to_layers()
			_rebuild_surface_spatial_index()
	)


## Resize the map to fit the terrain data
func _draw_map_size() -> void:
	if data == null:
		return
	if margin:
		var base_size := data.get_size()
		var margins := Vector2(margin_left_px + margin_right_px, margin_top_px + margin_bottom_px)
		var total := base_size + margins
		margin.size = total
		size = margin.size
	queue_redraw()


## Emit a resize event for base layer
func _on_base_layer_resize():
	emit_signal("map_resize")


## Build a spatial hash for polygon AREA surfaces.
func _rebuild_surface_spatial_index() -> void:
	_surface_index.clear()
	_surface_meta.clear()
	if data == null or data.surfaces == null:
		return

	var surfaces: Array = data.surfaces
	for i in surfaces.size():
		var s: Dictionary = surfaces[i]
		if typeof(s) != TYPE_DICTIONARY:
			continue
		if s.get("type", "") != "polygon":
			continue

		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue

		# Strip closing duplicate if present (prevents per-query copying).
		if pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-10:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue

		# Compute AABB once.
		var bbox := Rect2(pts[0], Vector2.ZERO)
		for p in pts:
			bbox = bbox.expand(p)

		# Store meta and bin into grid cells.
		var meta_idx := _surface_meta.size()
		(
			_surface_meta
			. append(
				{
					"pts": pts,
					"bbox": bbox,
					"z": float(brush.z_index),
					"data_idx": i,
				}
			)
		)

		var cs := float(surface_index_cell_m)
		var min_cx := int(floor(bbox.position.x / cs))
		var min_cy := int(floor(bbox.position.y / cs))
		var max_cx := int(floor((bbox.position.x + bbox.size.x) / cs))
		var max_cy := int(floor((bbox.position.y + bbox.size.y) / cs))

		for cx in range(min_cx, max_cx + 1):
			for cy in range(min_cy, max_cy + 1):
				var key := Vector2i(cx, cy)
				var bucket: PackedInt32Array = _surface_index.get(key, PackedInt32Array())
				bucket.append(meta_idx)
				_surface_index[key] = bucket


## Clamp a single point to the terrain (local map coordinates)
func clamp_point_to_terrain(p: Vector2) -> Vector2:
	var sz: Vector2 = get_terrain_size()
	return Vector2(
		clamp(p.x, 0.0, sz.x - terrain_border_px * 2), clamp(p.y, 0.0, sz.y - terrain_border_px * 2)
	)


## Clamp an entire polygon (without mutating the source array)
func clamp_shape_to_terrain(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	out.resize(pts.size())
	for i in pts.size():
		out[i] = clamp_point_to_terrain(pts[i])
	return out


## Helper function to convert terrain position to map position
func map_to_terrain(local_m: Vector2) -> Vector2:
	var map_margins := Vector2(margin_left_px, margin_top_px)
	var map_borders := Vector2(terrain_border_px, terrain_border_px)
	return local_m - map_margins - map_borders


## helepr function to convert map position to terrain position
func terrain_to_map(pos: Vector2) -> Vector2:
	var map_margins := Vector2(margin_left_px, margin_top_px)
	var map_borders := Vector2(terrain_border_px, terrain_border_px)
	return pos + map_margins + map_borders


func to_local(pos: Vector2) -> Vector2:
	return pos - global_position


## API to check if position is inside map
func is_inside_map(pos: Vector2) -> bool:
	return margin.get_rect().has_point(pos)


## API to check if position is inside terrain
func is_inside_terrain(pos: Vector2) -> bool:
	return base_layer.get_rect().has_point(pos)


## API to get grid number from terrain local position
func pos_to_grid(pos: Vector2, total_digits: int = 6) -> String:
	@warning_ignore("integer_division")
	var per_axis := total_digits / 2
	if per_axis != 3 and per_axis != 4 and per_axis != 5:
		push_warning(
			"pos_to_grid: total_digits must be 6, 8, or 10; got %d. Using 6." % total_digits
		)
		per_axis = 3

	var cell_x := floori(pos.x / GRID_SIZE_M)
	var cell_y := floori(pos.y / GRID_SIZE_M)

	var base_x := data.grid_start_x + cell_x
	var base_y := data.grid_start_y + cell_y

	var off_x := clampf(pos.x - float(cell_x) * GRID_SIZE_M, 0.0, 99.9999)
	var off_y := clampf(pos.y - float(cell_y) * GRID_SIZE_M, 0.0, 99.9999)

	var east: int
	var north: int

	match per_axis:
		3:
			east = base_x
			north = base_y
		4:
			east = base_x * 10 + int(floor(off_x / 10.0))
			north = base_y * 10 + int(floor(off_y / 10.0))
		5:
			east = base_x * 100 + int(floor(off_x))
			north = base_y * 100 + int(floor(off_y))

	var e_str := str(east).pad_zeros(per_axis)
	var n_str := str(north).pad_zeros(per_axis)
	return e_str + n_str


## API to get terrain local position from grid number
func grid_to_pos(grid: String) -> Vector2:
	var digits := ""
	for ch in grid:
		if ch.is_valid_int():
			digits += ch

	if digits.length() % 2 != 0:
		LogService.warning(
			"Grid label must have an even number of digits (6/8/10). Got: %s" % grid,
			"TerrainRender.gd:341"
		)
		return Vector2i.ZERO

	@warning_ignore("integer_division")
	var half := digits.length() / 2
	if half < 3 or half > 5:
		LogService.warning(
			"Grid label must be 6, 8, or 10 digits (got %d)." % digits.length(),
			"TerrainRender.gd:341"
		)
		return Vector2i.ZERO

	var east_str := digits.substr(0, half)
	var north_str := digits.substr(half, half)

	var gx_abs := east_str.substr(0, 3).to_int()
	var gy_abs := north_str.substr(0, 3).to_int()

	var cell_x := gx_abs - data.grid_start_x
	var cell_y := gy_abs - data.grid_start_y

	var x := cell_x * 100
	var y := cell_y * 100

	var extra_len := half - 3
	if extra_len > 0:
		var sub_x_str := east_str.substr(3, extra_len)
		var sub_y_str := north_str.substr(3, extra_len)

		var step := int(round(100 / pow(10.0, extra_len)))
		x += (0 if sub_x_str.is_empty() else sub_x_str.to_int()) * step
		y += (0 if sub_y_str.is_empty() else sub_y_str.to_int()) * step

	return Vector2i(x + 50, y + 50)


## API to get the map size
func get_terrain_size() -> Vector2:
	return base_layer.size


## API to get the map position
func get_terrain_position() -> Vector2:
	return base_layer.position


## Surface under a terrain-local position.
## Returns the topmost polygon AREA surface dict or {}.
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary:
	if data == null or data.surfaces == null:
		return {}

	var base_rect := Rect2(Vector2.ZERO, Vector2(data.width_m, data.height_m))
	if not base_rect.has_point(terrain_pos):
		return {}

	var best_z := -INF
	var best_data_idx := -1

	if not _surface_index.is_empty() and not _surface_meta.is_empty():
		var cs := float(surface_index_cell_m)
		var cell := Vector2i(int(floor(terrain_pos.x / cs)), int(floor(terrain_pos.y / cs)))
		var candidates: PackedInt32Array = _surface_index.get(cell, PackedInt32Array())

		for mi in candidates:
			var m: Dictionary = _surface_meta[mi]
			var bbox: Rect2 = m.bbox
			if not bbox.has_point(terrain_pos):
				continue
			var pts: PackedVector2Array = m.pts
			if Geometry2D.is_point_in_polygon(terrain_pos, pts):
				var z: int = m.z
				var d_idx: int = m.data_idx
				if (z > best_z) or (is_equal_approx(z, best_z) and d_idx > best_data_idx):
					best_z = z
					best_data_idx = d_idx

		if best_data_idx != -1:
			return data.surfaces[best_data_idx]

	var surfaces: Array = data.surfaces
	for i in surfaces.size():
		var s: Dictionary = surfaces[i]
		if typeof(s) != TYPE_DICTIONARY:
			continue
		if s.get("type", "") != "polygon":
			continue

		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue

		if pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-10:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue

		var bbox := Rect2(pts[0], Vector2.ZERO)
		for p in pts:
			bbox = bbox.expand(p)
		if not bbox.has_point(terrain_pos):
			continue

		if Geometry2D.is_point_in_polygon(terrain_pos, pts):
			var z := float(brush.z_index)
			if (z > best_z) or (is_equal_approx(z, best_z) and i > best_data_idx):
				best_z = z
				best_data_idx = i

	return {} if best_data_idx == -1 else data.surfaces[best_data_idx]


## Request a path in terrain meters via attached PathGrid
func nav_find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array:
	if not path_grid:
		return PackedVector2Array()
	return path_grid.find_path_m(start_m, goal_m)


## Estimate travel time (seconds) along a path for a given base speed and profile
func nav_estimate_time_s(path_m: PackedVector2Array, base_speed_mps: float, profile: int) -> float:
	if not path_grid:
		return INF
	return path_grid.estimate_travel_time_s(path_m, base_speed_mps, profile)
