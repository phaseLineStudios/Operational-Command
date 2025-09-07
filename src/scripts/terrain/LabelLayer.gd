extends Control
class_name LabelLayer

@export var outline_color: Color = Color.WHITE
@export var outline_size := 1
@export var text_color: Color = Color(0.05,0.05,0.05,1.0)
@export var font: Font
@export var antialias: bool = true

@onready var renderer: TerrainRender = get_owner()

var data: TerrainData
var _data_conn := false
var _dirty := false

func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
		_data_conn = false
	if _data_conn and data and data.is_connected("labels_changed", Callable(self, "_on_labels_changed")):
		data.disconnect("labels_changed", Callable(self, "_on_labels_changed"))
		_data_conn = false
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		data.labels_changed.connect(_on_labels_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

func apply_style(from: Node):
	if from == null:
		return
	if "outline_color" in from: outline_color = from.outline_color
	if "outline_size" in from: outline_size = from.outline_size
	if "text_color" in from: text_color = from.text_color
	if "font" in from: font = from.font
	if "antialias" in from: antialias = from.antialias

## Mark dirty for redraw
func mark_dirty():
	_dirty = true
	queue_redraw()

func _on_data_changed() -> void:
	queue_redraw()

func _on_labels_changed(kind: String, ids: PackedInt32Array):
	print("[DBG] Labels Changed (%s)" % ids)

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null or data.labels == null or data.labels.is_empty() or font == null:
		return

	var items: Array = []
	for s in data.labels:
		if s == null or not (s is Dictionary): 
			continue
		var pos_local: Vector2 = s.get("pos", Vector2.INF)
		if not pos_local.is_finite(): 
			continue
		if not renderer.is_inside_terrain(pos_local + Vector2(renderer.margin_left_px, renderer.margin_top_px)):
			continue
		var txt: String = String(s.get("text", ""))
		if txt == "": 
			continue
		var sz: int = int(s.get("size", 16))
		var z := int(s.get("z", 0))
		var rot := int(s.get("rot", 0.0))
		items.append({
			"pos":pos_local,
			"text":txt, 
			"size":sz,
			"rot": rot,
			"z":z
		})

	items.sort_custom(func(a,b): 
		return int(a.z) < int(b.z))

	for it in items:
		_draw_label_centered(it.pos, it.text, it.size, it.rot)

func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot: float) -> void:
	var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var ascent := font.get_ascent(font_size)
	var height := font.get_height(font_size)
	var baseline_local := Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)
	var ang := deg_to_rad(rot)
	draw_set_transform(pos_local, ang, Vector2.ONE)

	if outline_size > 0 and outline_color.a > 0.0:
		draw_string_outline(font, baseline_local, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, outline_size, outline_color)
	draw_string(font, baseline_local, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, text_color)

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
