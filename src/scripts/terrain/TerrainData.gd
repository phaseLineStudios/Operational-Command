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
## Surfaces: { id:int, brush:TerrainBrush, type:String, points:PackedVector2Array, closed:bool }.
@export var surfaces: Array = [] : set = _set_surfaces
## Lines: { id:int, brush:TerrainBrush, points:PackedVector2Array, closed:bool, width_px:float }.
@export var lines: Array = [] : set = _set_lines
## Points: { id:int, brush:TerrainBrush, pos:Vector2, rot:float, scale:float }.
@export var points: Array = [] : set = _set_points
## Labels: { id:int, text:String, pos:Vector2, size:int, rot:float, z:int }.
@export var labels: Array = [] : set = _set_labels

var _px_per_m: float = 1.0

## Emits when the elevation image block changes.
signal elevation_changed(rect: Rect2i)
## Emits when surfaces mutate. kind: "reset|added|removed|points|brush|meta".
signal surfaces_changed(kind: String, ids: PackedInt32Array)
## Emits when lines mutate. kind: "reset|added|removed|points|style|meta".
signal lines_changed(kind: String, ids: PackedInt32Array)
## Emits when points mutate. kind: "reset|added|removed|move|style|meta".
signal points_changed(kind: String, ids: PackedInt32Array)
## Emits when labels mutate. kind: "reset|added|removed|move|style|meta".
signal labels_changed(kind: String, ids: PackedInt32Array)

@warning_ignore("unused_private_class_variable")
var _next_surface_id := 1
@warning_ignore("unused_private_class_variable")
var _next_line_id := 1
@warning_ignore("unused_private_class_variable")
var _next_point_id := 1
@warning_ignore("unused_private_class_variable")
var _next_label_id := 1

var _batch_depth := 0
var _pend_surfaces: Array = []
var _pend_lines: Array = []
var _pend_points: Array = []
var _pend_labels: Array = []

## Begin a batch - defers granular signals until end_batch().
func begin_batch() -> void:
	_batch_depth += 1

## End a batch - emits coalesced signals.
func end_batch() -> void:
	if _batch_depth <= 0:
		return
	_batch_depth -= 1
	if _batch_depth > 0:
		return
	_emit_coalesced(_pend_surfaces, surfaces_changed)
	_emit_coalesced(_pend_lines, lines_changed)
	_emit_coalesced(_pend_points, points_changed)
	_emit_coalesced(_pend_labels, labels_changed)

func _emit_coalesced(pend: Array, sig: Signal) -> void:
	if pend.is_empty():
		return
	var by_kind := {}
	for e in pend:
		var k: String = e[0]
		var ids: PackedInt32Array = e[1]
		if not by_kind.has(k):
			by_kind[k] = ids.duplicate()
		else:
			var dst: PackedInt32Array = by_kind[k]
			for i in ids:
				if not dst.has(i):
					dst.append(i)
	pend.clear()
	for k in by_kind.keys():
		emit_signal(sig.get_name(), k, by_kind[k])

func _init() -> void:
	_update_scale()

func _set_width(v: int) -> void:
	width_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

func _set_height(v: int) -> void:
	height_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

func _set_resolution(v: int) -> void:
	elevation_resolution_m = clamp(v, 2, 200)
	_resample_or_resize()
	emit_signal("changed")

func _set_grid_x(_v: int) -> void:
	grid_start_x = _v
	emit_signal("changed")

func _set_grid_y(_v: int) -> void:
	grid_start_y = _v
	emit_signal("changed")

func _set_elev(img: Image) -> void:
	if img.is_empty():
		elevation = Image.create(64, 64, false, Image.FORMAT_RF)
	else:
		elevation = img
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")

func _set_contour_interval_m(v):
	contour_interval_m = v
	emit_signal("changed")

# Ensure IDs on bulk assigns; emit granular “reset”.
func _set_surfaces(v) -> void:
	surfaces = _ensure_ids(v, "_next_surface_id")
	_queue_emit(_pend_surfaces, "reset", _collect_ids(surfaces))
	emit_signal("changed")

func _set_lines(v) -> void:
	lines = _ensure_ids(v, "_next_line_id")
	_queue_emit(_pend_lines, "reset", _collect_ids(lines))
	emit_signal("changed")

func _set_points(v) -> void:
	points = _ensure_ids(v, "_next_point_id")
	_queue_emit(_pend_points, "reset", _collect_ids(points))
	emit_signal("changed")

func _set_labels(v) -> void:
	labels = _ensure_ids(v, "_next_label_id")
	_queue_emit(_pend_labels, "reset", _collect_ids(labels))
	emit_signal("changed")

## Add a new surface. Returns the assigned id.
func add_surface(s: Dictionary) -> int:
	var id := _ensure_id_on_item(s, "_next_surface_id")
	surfaces.append(s)
	_queue_emit(_pend_surfaces, "added", PackedInt32Array([id]))
	return id

## Update surface points by id (fast path while drawing).
func set_surface_points(id: int, pts: PackedVector2Array) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0: return
	surfaces[i].points = pts
	_queue_emit(_pend_surfaces, "points", PackedInt32Array([id]))

## Update surface brush or metadata by id.
func set_surface_brush(id: int, brush: Resource) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0: return
	surfaces[i].brush = brush
	_queue_emit(_pend_surfaces, "brush", PackedInt32Array([id]))

## Remove surface by id.
func remove_surface(id: int) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0: return
	surfaces.remove_at(i)
	_queue_emit(_pend_surfaces, "removed", PackedInt32Array([id]))

## Lines (similar pattern)
func add_line(l: Dictionary) -> int:
	var id := _ensure_id_on_item(l, "_next_line_id")
	lines.append(l)
	_queue_emit(_pend_lines, "added", PackedInt32Array([id]))
	return id

func set_line_points(id: int, pts: PackedVector2Array) -> void:
	var i := _find_by_id(lines, id)
	if i < 0: return
	lines[i].points = pts
	_queue_emit(_pend_lines, "points", PackedInt32Array([id]))

func set_line_style(id: int, width_px: float) -> void:
	var i := _find_by_id(lines, id)
	if i < 0: return
	lines[i].width_px = width_px
	_queue_emit(_pend_lines, "style", PackedInt32Array([id]))

func remove_line(id: int) -> void:
	var i := _find_by_id(lines, id)
	if i < 0: return
	lines.remove_at(i)
	_queue_emit(_pend_lines, "removed", PackedInt32Array([id]))

## Points
func add_point(p: Dictionary) -> int:
	var id := _ensure_id_on_item(p, "_next_point_id")
	points.append(p)
	_queue_emit(_pend_points, "added", PackedInt32Array([id]))
	return id

func set_point_transform(id: int, pos: Vector2, rot: float, scale: float=1.0) -> void:
	var i := _find_by_id(points, id)
	if i < 0: return
	points[i].pos = pos
	points[i].rot = rot
	points[i].scale = scale
	_queue_emit(_pend_points, "move", PackedInt32Array([id]))

func remove_point(id: int) -> void:
	var i := _find_by_id(points, id)
	if i < 0: return
	points.remove_at(i)
	_queue_emit(_pend_points, "removed", PackedInt32Array([id]))

## Labels
func add_label(lab: Dictionary) -> int:
	var id := _ensure_id_on_item(lab, "_next_label_id")
	labels.append(lab)
	_queue_emit(_pend_labels, "added", PackedInt32Array([id]))
	return id

func set_label_pose(id: int, pos: Vector2, rot: float) -> void:
	var i := _find_by_id(labels, id)
	if i < 0: return
	labels[i].pos = pos
	labels[i].rot = rot
	_queue_emit(_pend_labels, "move", PackedInt32Array([id]))

func set_label_style(id: int, size: int) -> void:
	var i := _find_by_id(labels, id)
	if i < 0: return
	labels[i].size = size
	_queue_emit(_pend_labels, "style", PackedInt32Array([id]))

func remove_label(id: int) -> void:
	var i := _find_by_id(labels, id)
	if i < 0: return
	labels.remove_at(i)
	_queue_emit(_pend_labels, "removed", PackedInt32Array([id]))

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
			out[k] = elevation.get_pixel(r.position.x + x, r.position.y + y).r
			k += 1
	return out

func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void:
	if elevation == null or elevation.is_empty():
		return
	var r := _clip_rect_to_image(rect, elevation)
	if r.size.x <= 0 or r.size.y <= 0:
		return
	if block.size() != r.size.x * r.size.y:
		push_warning("set_elevation_block: size mismatch")
		return
	var k := 0
	for y in r.size.y:
		for x in r.size.x:
			var v := block[k]
			elevation.set_pixel(r.position.x + x, r.position.y + y, Color(v, 0.0, 0.0, 1.0))
			k += 1
	emit_signal("elevation_changed", r)

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
	emit_signal("elevation_changed", Rect2i(px, Vector2i(1,1)))

## Convert world meters to elevation pixel coords.
func world_to_elev_px(p: Vector2) -> Vector2i:
	return Vector2i(int(round(p.x / elevation_resolution_m)), int(round(p.y / elevation_resolution_m)))

## Convert elevation pixel coords to world meters (top-left origin).
func elev_px_to_world(px: Vector2i) -> Vector2:
	return Vector2(px.x * elevation_resolution_m, px.y * elevation_resolution_m)

static func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i:
	var w := img.get_width()
	var h := img.get_height()
	if w <= 0 or h <= 0:
		return Rect2i()
	var x0: int = clamp(rect.position.x, 0, w)
	var y0: int = clamp(rect.position.y, 0, h)
	var x1: int = clamp(rect.position.x + rect.size.x, 0, w)
	var y1: int = clamp(rect.position.y + rect.size.y, 0, h)
	return Rect2i(Vector2i(x0, y0), Vector2i(max(0, x1 - x0), max(0, y1 - y0)))

func _update_scale() -> void:
	if elevation.is_empty(): return
	_px_per_m = float(elevation.get_width()) / float(max(width_m, 1))

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

func _ensure_ids(arr: Array, counter_prop: String) -> Array:
	var out := []
	for it in arr:
		var item: Dictionary = it
		if item is Dictionary:
			if not item.has("id") or int(item.id) <= 0:
				item.id = self.get(counter_prop)
				self.set(counter_prop, int(self.get(counter_prop)) + 1)
		out.append(item)
	return out

func _ensure_id_on_item(item: Dictionary, counter_prop: String) -> int:
	if not item.has("id") or int(item.id) <= 0:
		item.id = self.get(counter_prop)
		self.set(counter_prop, int(self.get(counter_prop)) + 1)
	return int(item.id)

func _collect_ids(arr: Array) -> PackedInt32Array:
	var ids := PackedInt32Array()
	for it in arr:
		if it is Dictionary and it.has("id"):
			ids.append(int(it.id))
	return ids

func _find_by_id(arr: Array, id: int) -> int:
	for i in arr.size():
		var it = arr[i]
		if it is Dictionary and it.has("id") and int(it.id) == id:
			return i
	return -1

func _queue_emit(bucket: Array, kind: String, ids: PackedInt32Array) -> void:
	if _batch_depth > 0:
		bucket.append([kind, ids])
	else:
		var sig_name := ""
		if bucket == _pend_surfaces: sig_name = "surfaces_changed"
		elif bucket == _pend_lines: sig_name = "lines_changed"
		elif bucket == _pend_points: sig_name = "points_changed"
		elif bucket == _pend_labels: sig_name = "labels_changed"
		emit_signal(sig_name, kind, ids)
