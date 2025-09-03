extends Control
class_name LabelLayer

@export var outline_color: Color = Color(1,1,1,1)  # white outline fallback
@export var text_color: Color = Color(0.05,0.05,0.05,1.0)
@export var font: Font
@export var antialias: bool = true

var data: TerrainData
var _data_conn := false

func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
		_data_conn = false
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

func _on_data_changed() -> void:
	queue_redraw()

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
		var txt: String = String(s.get("text", ""))
		if txt == "": 
			continue
		var sz: int = int(s.get("size", 16))
		var z := int(s.get("z", 0))  # optional
		items.append({"p":pos_local, "t":txt, "s":sz, "z":z})

	items.sort_custom(func(a,b): 
		return int(a.z) < int(b.z))

	for it in items:
		_draw_label_centered(it.p, it.t, it.s)

func _draw_label_centered(pos_local: Vector2, text: String, font_size: int) -> void:
	var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var ascent := font.get_ascent(font_size)
	var height := font.get_height(font_size)
	var baseline := pos_local + Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)

	var oc := outline_color
	var offs := [
		Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1),
		Vector2(-1,-1), Vector2(1,-1), Vector2(-1, 1), Vector2(1, 1)
	]
	for o in offs:
		draw_string(font, baseline + o, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, oc)

	draw_string(font, baseline, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, text_color)
