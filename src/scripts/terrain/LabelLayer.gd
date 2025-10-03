class_name LabelLayer
extends Control

## Outline color for labels
@export var outline_color: Color = Color.WHITE
## Outline thickness in pixels (>=1 draws outline)
@export var outline_size := 1
## Fill color for label text
@export var text_color: Color = Color(0.05, 0.05, 0.05, 1.0)
## Font resource used for labels
@export var font: Font
## Unused by text, kept for consistency
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
		and data.is_connected("labels_changed", Callable(self, "_on_labels_changed"))
	):
		data.disconnect("labels_changed", Callable(self, "_on_labels_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	if data:
		data.labels_changed.connect(
			_on_labels_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
		)
		_data_conn = true
	queue_redraw()


## Apply style fields from TerrainRender
func apply_style(from: Node):
	if from == null:
		return
	if "outline_color" in from:
		outline_color = from.outline_color
	if "outline_size" in from:
		outline_size = from.outline_size
	if "text_color" in from:
		text_color = from.text_color
	if "font" in from:
		font = from.font
	if "antialias" in from:
		antialias = from.antialias
	_draw_dirty = true
	queue_redraw()


## Marks the whole layer as dirty and queues a redraw (forces full rebuild)
func mark_dirty():
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	queue_redraw()


## Handles TerrainData label mutations and marks affected labels dirty
func _on_labels_changed(kind: String, ids: PackedInt32Array):
	match kind:
		"reset":
			_items.clear()
			_draw_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id)
		"removed":
			for id in ids:
				_items.erase(id)
			_draw_dirty = true
		"move":
			for id in ids:
				_refresh_pose_only(id)
		"style", "meta":
			for id in ids:
				_upsert_from_data(id)
		_:
			_items.clear()
			_draw_dirty = true
	queue_redraw()


## Redraw on resize so strokes match current Control rect
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	if data == null or font == null:
		return

	if _items.is_empty() and data.labels and not data.labels.is_empty():
		for s in data.labels:
			if s is Dictionary:
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id)

	if _draw_dirty:
		_rebuild_draw_items()

	for it in _draw_items:
		_draw_label_centered(it.pos, it.text, it.size, it.rot)


## Insert/update a label from TerrainData
func _upsert_from_data(id: int) -> void:
	var l: Variant = _find_label_by_id(id)
	if l == null:
		_items.erase(id)
		_draw_dirty = true
		return

	var pos: Vector2 = l.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return

	var txt: String = String(l.get("text", ""))
	if txt == "":
		_items.erase(id)
		_draw_dirty = true
		return

	var l_size: int = int(l.get("size", 16))
	var z: int = int(l.get("z", 0))
	var rot: float = float(l.get("rot", 0.0))
	var l_visible := _is_terrain_pos_visible(pos)

	var it: Variant = _items.get(
		id, {"pos": pos, "text": txt, "size": l_size, "rot": rot, "z": z, "visible": l_visible}
	)
	it.pos = pos
	it.text = txt
	it.size = l_size
	it.rot = rot
	it.z = z
	it.visible = l_visible

	_items[id] = it
	_draw_dirty = true


## Update position/rotation only (fast path for drags)
func _refresh_pose_only(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id)
		return
	var l: Variant = _find_label_by_id(id)
	if l == null:
		_items.erase(id)
		_draw_dirty = true
		return
	var pos: Vector2 = l.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return
	var rot: float = float(l.get("rot", 0.0))
	var it = _items[id]
	it.pos = pos
	it.rot = rot
	it.visible = _is_terrain_pos_visible(pos)
	_items[id] = it
	_draw_dirty = true


## Build sorted list from cache
func _rebuild_draw_items() -> void:
	_draw_dirty = false
	_draw_items.clear()
	if _items.is_empty():
		return
	var tmp := []
	for id in _items.keys():
		var it = _items[id]
		if it.visible and it.text != "":
			tmp.append(it)
	tmp.sort_custom(func(a, b): return int(a.z) < int(b.z))
	_draw_items = tmp


## Draw a centered label with a robust outline (multi-offset fallback)
func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot_deg: float) -> void:
	var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var ascent := font.get_ascent(font_size)
	var height := font.get_height(font_size)
	var baseline_local := Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)
	var ang := deg_to_rad(rot_deg)

	draw_set_transform(pos_local, ang, Vector2.ONE)

	if outline_size > 0 and outline_color.a > 0.0:
		draw_string_outline(
			font,
			baseline_local,
			text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			outline_size,
			outline_color
		)

		var r: int = max(1, int(outline_size))
		var offsets := [
			Vector2(-r, 0),
			Vector2(r, 0),
			Vector2(0, -r),
			Vector2(0, r),
			Vector2(-r, -r),
			Vector2(-r, r),
			Vector2(r, -r),
			Vector2(r, r)
		]
		for o in offsets:
			draw_string(
				font,
				baseline_local + o,
				text,
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				font_size,
				outline_color
			)

	draw_string(font, baseline_local, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, text_color)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Visibility test against terrain rect (same as other layers)
func _is_terrain_pos_visible(pos_local: Vector2) -> bool:
	return renderer.is_inside_terrain(
		pos_local + Vector2(renderer.margin_left_px, renderer.margin_top_px)
	)


## Find a label dictionary in TerrainData by id
func _find_label_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.labels:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
