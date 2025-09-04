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
## The base elevation of the terrain in meters.
@export var base_elevation_m: int = 0
## Contour interval in meters.
@export var contour_interval_m: int = 10 : set = _set_contour_interval_m
## Elevation image (R channel = meters; 16F or 32F preferred).
@export var elevation: Image = Image.create(64, 64, false, Image.FORMAT_RF) : set = _set_elev

@export_group("Content")
## List of surface shapes. Each: { "brush": TerrainBrush, "type": "freehand|line|polygon", "points": PackedVector2Array, "closed": bool }.
@export var surfaces: Array = [] : set = _set_surfaces
## List of lines features. Each: { "res": TerrainFeature, "type": "freehand|line", "points": PackedVector2Array, "closed": bool, "width": float }.
@export var lines: Array = [] : set = _set_lines
## List of point features. Each: { "res": TerrainFeature, "pos": Vector2, "rot": float }.
@export var points: Array = [] : set = _set_points
## List of text labels. Each: { "text": String, "pos": Vector2, "size": int, "rot": float }.
@export var labels: Array = [] : set = _set_labels

var _px_per_m: float = 1.0

## emits when the elevation is changed
signal elevation_changed(rect: Rect2i)

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

## Set surfaces variable
func _set_surfaces(v) -> void:
	surfaces = v
	_touch()
	
## Set points variable
func _set_lines(v) -> void:
	lines = v
	_touch()

## Set points variable
func _set_points(v) -> void:
	points = v
	_touch()
	
## Set surfaces variable
func _set_labels(v) -> void:
	labels = v
	_touch()

func _set_contour_interval_m(v):
	contour_interval_m = v
	_touch()

## Emit changed signal when data is changed
func _touch() -> void:
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
	if elevation.is_empty(): 
		return 0.0
	var w := elevation.get_width()
	var h := elevation.get_height()
	var x: int = clamp(px.x, 0, w - 1)
	var y: int = clamp(px.y, 0, h - 1)
	return elevation.get_pixel(x, y).r

## Set elevation (meters) at sample coord.
func set_elev_px(px: Vector2i, meters: float) -> void:
	if elevation.is_empty(): 
		return
	if px.x < 0 or px.y < 0 or px.x >= elevation.get_width() or px.y >= elevation.get_height(): 
		return
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
 
## Returns a row-major block of elevation samples (r channel) for the clipped rect.
func get_elevation_block(rect: Rect2i) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	if elevation == null or elevation.is_empty():
		return out

	var r := _clip_rect_to_image(rect, elevation)
	if r.size.x <= 0 or r.size.y <= 0:
		return out

	out.resize(r.size.x * r.size.y)

	var k := 0
	for y in r.size.y:
		for x in r.size.x:
			var v := elevation.get_pixel(r.position.x + x, r.position.y + y).r
			out[k] = v
			k += 1
	return out


## Writes a row-major block of elevation samples (r channel) into the clipped rect.
func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void:
	if elevation == null or elevation.is_empty():
		return

	var r := _clip_rect_to_image(rect, elevation)
	if r.size.x <= 0 or r.size.y <= 0:
		return

	var expected := r.size.x * r.size.y
	if block.size() != expected:
		push_warning("set_elevation_block: block size ", block.size(), " does not match rect (", expected, ")")
		return

	var k := 0
	for y in r.size.y:
		for x in r.size.x:
			var v := block[k]
			elevation.set_pixel(r.position.x + x, r.position.y + y, Color(v, 0.0, 0.0, 1.0))
			k += 1

	if has_signal("elevation_changed"):
		emit_signal("elevation_changed", r)
	elif has_signal("changed"):
		emit_signal("changed")


## Helper function to clip a rect to image bounds
static func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i:
	var w := img.get_width()
	var h := img.get_height()
	if w <= 0 or h <= 0:
		return Rect2i()

	var x0: int = clamp(rect.position.x, 0, w)
	var y0: int = clamp(rect.position.y, 0, h)
	var x1: int = clamp(rect.position.x + rect.size.x, 0, w)
	var y1: int = clamp(rect.position.y + rect.size.y, 0, h)

	var cw: int = max(0, x1 - x0)
	var ch: int = max(0, y1 - y0)
	return Rect2i(Vector2i(x0, y0), Vector2i(cw, ch))

## Create a deep copy of itself
func duplicate_deep() -> TerrainData:
	var copy := TerrainData.new()

	copy.name = name
	copy.width_m = width_m
	copy.height_m = height_m
	copy.elevation_resolution_m = elevation_resolution_m

	copy.grid_start_x = grid_start_x
	copy.grid_start_y = grid_start_y

	copy.base_elevation_m = base_elevation_m
	copy.contour_interval_m = contour_interval_m

	if elevation and not elevation.is_empty():
		copy.elevation = elevation.duplicate()
	else:
		copy.elevation = Image.create(64, 64, false, Image.FORMAT_RF)

	copy.surfaces = []
	for s in surfaces:
		copy.surfaces.append(s.duplicate(true) if s is Resource else s)
	copy.lines = []
	for l in lines:
		copy.lines.append(l.duplicate(true) if l is Resource else l)
	copy.points = []
	for p in points:
		copy.points.append(p.duplicate(true) if p is Resource else p)
	copy.labels = []
	for lab in labels:
		copy.labels.append(lab.duplicate(true) if lab is Resource else lab)

	copy._px_per_m = _px_per_m

	return copy
