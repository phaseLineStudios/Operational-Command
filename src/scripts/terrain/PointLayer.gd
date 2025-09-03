extends Control
class_name PointLayer

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
	if data == null or data.points == null or data.points.is_empty():
		return

	var items: Array = []
	for s in data.points:
		if s == null or not (s is Dictionary): continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.POINT:
			continue
		var tex: Texture2D = brush.symbol
		if tex == null: continue

		var pos_local: Vector2 = s.get("pos", Vector2.INF)
		if not pos_local.is_finite(): continue
		var p_scale: float = float(s.get("scale", 1.0))
		var p_size = brush.symbol_size_m * max(0.01, p_scale)

		items.append({
			"pos_local": pos_local,
			"tex": tex,
			"size": p_size,
			"z": brush.z_index
		})

	items.sort_custom(func(a, b): return int(a.z) < int(b.z))

	for it in items:
		var pos_local: Vector2 = it.pos_local
		var tex: Texture2D = it.tex
		var sc: float = it.size

		var p_size := Vector2(sc, sc)
		var top_left := pos_local - p_size * 0.5

		var rect := Rect2(top_left, p_size)
		draw_texture_rect(tex, rect, false)
