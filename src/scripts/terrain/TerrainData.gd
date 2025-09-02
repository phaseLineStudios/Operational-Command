extends Resource
class_name TerrainData

## Terrain model: size, elevation, surfaces, features, labels.

## Name of the terrain.
@export var name: String

## Width of the map in meters.
@export var width_m: int = 2000 : set = _set_width
## Height of the map in meters.
@export var height_m: int = 2000 : set = _set_height
## World meters per elevation sample (grid step). Lower = denser.
@export var elevation_resolution_m: int = 20 : set = _set_resolution

@export_group("Grid")
## Starting number on X axis labels.
@export var grid_start_x: int = 100 : set = _set_grid_x
## Starting number on Y axis labels.
@export var grid_start_y: int = 100 : set = _set_grid_y

@export_group("Elevation")
## Contour interval in meters.
@export var contour_interval_m: int = 10 : set = _touch
## Elevation image (R channel = meters; 16F or 32F preferred).
@export var elevation: Image = Image.create(64, 64, false, Image.FORMAT_RF) : set = _set_elev

@export_group("Content")
## List of surface shapes. Each: { "brush": TerrainBrush, "type": "freehand|line|polygon", "points": PackedVector2Array, "closed": bool }.
@export var surfaces: Array = [] : set = _touch
## List of point features. Each: { "res": TerrainFeature, "pos": Vector2, "rot": float }.
@export var points: Array = [] : set = _touch
## List of text labels. Each: { "text": String, "pos": Vector2, "size": int, "rot": float }.
@export var labels: Array = [] : set = _touch

var _px_per_m: float = 1.0

func _init() -> void:
	_update_scale()

## Set terrain width (meters).
func _set_width(v: int) -> void:
	width_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

## Set terrain height (meters).
func _set_height(v: int) -> void:
	height_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

## Set elevation resolution (meters).
func _set_resolution(v: int) -> void:
	elevation_resolution_m = clamp(v, 2, 200)
	_resample_or_resize()
	emit_signal("changed")

## Set the starting grid for the X axis
func _set_grid_x(_v: int) -> void:
	grid_start_x = _v
	emit_signal("changed")

## Set the starting grid for the Y axis
func _set_grid_y(_v: int) -> void:
	grid_start_y = _v
	emit_signal("changed")

## Set elevation heightmap
func _set_elev(img: Image) -> void:
	if img.is_empty():
		elevation = Image.create(64, 64, false, Image.FORMAT_RF)
	else:
		elevation = img
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

## Emit changed signal when data is changed
func _touch(_value) -> void:
	emit_signal("changed")

## Update heightmap scale
func _update_scale() -> void:
	if elevation.is_empty():
		return
	_px_per_m = float(elevation.get_width()) / float(max(width_m, 1))

## Resmaple or resize heightmap
func _resample_or_resize() -> void:
	var new_w := int(round(float(width_m) / elevation_resolution_m))
	var new_h := int(round(float(height_m) / elevation_resolution_m))
	new_w = max(new_w, 8)
	new_h = max(new_h, 8)
	if elevation.get_width() == new_w and elevation.get_height() == new_h:
		return
	var old := elevation.duplicate()
	elevation = Image.create(new_w, new_h, false, Image.FORMAT_RF)
	elevation.fill(Color(0,0,0))
	if not old.is_empty():
		old.resize(new_w, new_h, Image.INTERPOLATE_NEAREST)
		elevation.blit_rect(old, Rect2i(Vector2i.ZERO, old.get_size()), Vector2i.ZERO)

## Get terrain size (meters).
func get_size() -> Vector2:
	return Vector2(width_m, height_m)

## Get elevation (meters) at sample coord.
func get_elev_px(px: Vector2i) -> float:
	if elevation.is_empty(): return 0.0
	var w := elevation.get_width()
	var h := elevation.get_height()
	var x: int = clamp(px.x, 0, w - 1)
	var y: int = clamp(px.y, 0, h - 1)
	return elevation.get_pixel(x, y).r

## Set elevation (meters) at sample coord.
func set_elev_px(px: Vector2i, meters: float) -> void:
	if elevation.is_empty(): return
	if px.x < 0 or px.y < 0 or px.x >= elevation.get_width() or px.y >= elevation.get_height(): return
	elevation.set_pixel(px.x, px.y, Color(meters, 0, 0))
	emit_signal("changed")

## Convert world meters to elevation pixel coords.
func world_to_elev_px(p: Vector2) -> Vector2i:
	var sx := int(round(p.x / elevation_resolution_m))
	var sy := int(round(p.y / elevation_resolution_m))
	return Vector2i(sx, sy)

## Convert elevation pixel coords to world meters (top-left origin).
func elev_px_to_world(px: Vector2i) -> Vector2:
	return Vector2(px.x * elevation_resolution_m, px.y * elevation_resolution_m)
 
## Get the grid number of a position
func position_to_grid(_pos: Vector2):
	pass # TODO

## Get the surface of a position
func get_surface_at_pos(_pos: Vector2):
	pass # TODO

## Get the elevation of a position
func get_elev_at_pos(_pos: Vector2):
	pass # TODO
