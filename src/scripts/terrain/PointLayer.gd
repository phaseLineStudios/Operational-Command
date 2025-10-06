class_name PointLayer
extends Control

## Enable antialiasing
@export var antialias: bool = true

var data: TerrainData
var _data_conn := false

var _items: Dictionary = {}
var _draw_items: Array = []
var _draw_dirty := true

@onready var renderer: TerrainRender = get_owner()


## Assigns TerrainData, resets caches, wires signals, and schedules redraw
func set_data(d: TerrainData) -> void:
	if (
		_data_conn
		and data
		and data.is_connected("points_changed", Callable(self, "_on_points_changed"))
	):
		data.disconnect("points_changed", Callable(self, "_on_points_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	if data:
		data.points_changed.connect(
			_on_points_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
		)
		_data_conn = true
	queue_redraw()


## Marks the whole layer as dirty and queues a redraw (forces full rebuild)
func mark_dirty() -> void:
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	queue_redraw()


## Handles TerrainData point mutations and marks affected points dirty
func _on_points_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_items.clear()
			_draw_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id, true)
		"removed":
			for id in ids:
				_items.erase(id)
			_draw_dirty = true
		"move":
			for id in ids:
				_refresh_pose(id)
		"style", "brush", "meta":
			for id in ids:
				_upsert_from_data(id, true)
		_:
			_items.clear()
			_draw_dirty = true
	queue_redraw()


## Redraw on resize so points match current Control rect.
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	if data == null:
		return

	if _items.is_empty() and data.points and not data.points.is_empty():
		for s in data.points:
			if s is Dictionary:
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id, true)

	if _draw_dirty:
		_rebuild_draw_items()

	for it in _draw_items:
		var pos_local: Vector2 = it.pos
		var tex: Texture2D = it.tex
		var sc: float = it.size
		var rot := deg_to_rad(float(it.rot))

		var half := Vector2(sc, sc) * 0.5
		var rect := Rect2(-half, Vector2(sc, sc))

		draw_set_transform(pos_local, rot, Vector2.ONE)
		draw_texture_rect(tex, rect, false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Insert/update a point by id, recomputing size/tex/visibility as needed
func _upsert_from_data(id: int, rebuild_all: bool) -> void:
	var point: Variant = _find_point_by_id(id)
	if point == null:
		_items.erase(id)
		_draw_dirty = true
		return

	var brush: TerrainBrush = point.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.POINT:
		_items.erase(id)
		_draw_dirty = true
		return

	var tex: Texture2D = brush.symbol
	if tex == null:
		_items.erase(id)
		_draw_dirty = true
		return

	var pos: Vector2 = point.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return

	var rot: float = float(point.get("rot", 0.0))
	var p_scale: float = float(point.get("scale", 1.0))
	var p_size: float = brush.symbol_size_m * max(0.01, p_scale)

	var p_visible := _is_terrain_pos_visible(pos)

	var it: Dictionary = _items.get(
		id,
		{
			"pos": Vector2.ZERO,
			"rot": 0.0,
			"scale": 1.0,
			"size": p_size,
			"tex": tex,
			"z": int(brush.z_index),
			"visible": p_visible
		}
	)

	it.pos = pos
	it.rot = rot
	it.scale = p_scale
	it.size = p_size
	if rebuild_all:
		it.tex = tex
		it.z = int(brush.z_index)
	it.visible = p_visible

	_items[id] = it
	_draw_dirty = true


## Update only pos/rot/scale/size/visibility
func _refresh_pose(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id, false)
		return
	var point: Variant = _find_point_by_id(id)
	if point == null:
		_items.erase(id)
		_draw_dirty = true
		return
	var pos: Vector2 = point.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return
	var rot: float = float(point.get("rot", 0.0))
	var p_scale: float = float(point.get("scale", 1.0))
	var brush: TerrainBrush = point.get("brush", null)
	var p_size: float = (brush.symbol_size_m if brush else 1.0) * max(0.01, p_scale)
	var it = _items[id]
	it.pos = pos
	it.rot = rot
	it.scale = p_scale
	it.size = p_size
	it.visible = _is_terrain_pos_visible(pos)
	_items[id] = it
	_draw_dirty = true


## Build/refresh array used by _draw(), sorted by z
func _rebuild_draw_items() -> void:
	_draw_dirty = false
	_draw_items.clear()
	if _items.is_empty():
		return

	var tmp := []
	for id in _items.keys():
		var it = _items[id]
		if it.visible and it.tex != null:
			tmp.append(it)

	tmp.sort_custom(
		func(a, b):
			return (str(a.tex) < str(b.tex)) if (int(a.z) == int(b.z)) else (int(a.z) < int(b.z))
	)

	_draw_items = tmp


## Reuse your original visibility test against terrain rect
func _is_terrain_pos_visible(pos_local: Vector2) -> bool:
	return renderer.is_inside_terrain(
		pos_local + Vector2(renderer.margin_left_px, renderer.margin_top_px)
	)


## Find a point dictionary in TerrainData by id
func _find_point_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.points:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
