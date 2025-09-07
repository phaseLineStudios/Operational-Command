extends TerrainToolBase
class_name TerrainPointTool

@export var active_brush: TerrainBrush
@export_range(0.1, 4.0, 0.1) var symbol_scale: float = 1.0

var _info_ui_parent: Control

var _hover_idx: int = -1
var _drag_idx: int = -1
var _is_drag := false
var _drag_before: Dictionary = {}
var _pick_radius_px := 12.0

func _init():
	tool_icon = preload("res://assets/textures/ui/editors_point_tool.png")
	tool_hint = "Point Tool"

func _load_brushes() -> void:
	brushes.clear()
	var dir := DirAccess.open("res://assets/terrain_brushes/")
	if dir:
		for f in dir.get_files():
			if f.ends_with(".tres") or f.ends_with(".res"):
				var r := ResourceLoader.load("res://assets/terrain_brushes/%s" % f)
				if r is TerrainBrush and r.feature_type == TerrainBrush.FeatureType.POINT:
					brushes.append(r)

func build_options_ui(p: Control) -> void:
	_load_brushes()

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_child(vb)

	vb.add_child(_label("Feature Brush"))
	var list := ItemList.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list.custom_minimum_size = Vector2(0, 160)

	var map_index: Array[int] = []
	for i in brushes.size():
		var b: TerrainBrush = brushes[i]
		list.add_item(b.legend_title)
		map_index.append(i)
	list.item_selected.connect(func(i):
		if i >= 0 and i < map_index.size():
			active_brush = brushes[map_index[i]]
			_rebuild_info_ui()
			_update_preview_appearance()
	)
	vb.add_child(list)

	var s := HSlider.new()
	s.min_value = 0.1
	s.max_value = 4.0
	s.step = 0.1
	s.value = symbol_scale
	s.value_changed.connect(func(v):
		symbol_scale = v
		_update_preview_appearance()
	)
	vb.add_child(_label("Symbol scale"))
	vb.add_child(s)

func build_info_ui(parent: Control) -> void:
	_info_ui_parent = parent
	_rebuild_info_ui()

func build_hint_ui(parent: Control) -> void:
	parent.add_child(_label("LMB - Place"))

func _rebuild_info_ui() -> void:
	if not _info_ui_parent or not active_brush:
		return
	_queue_free_children(_info_ui_parent)
	var l := RichTextLabel.new()
	l.bbcode_enabled = true
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.text = "Place point features"
	_info_ui_parent.add_child(l)

func build_preview(overlay_parent: Node) -> Control:
	_preview = SymbolPreview.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.brush = active_brush
	_preview.z_index = 100
	overlay_parent.add_child(_preview)
	_update_preview_appearance()
	return _preview

func _place_preview(local_px: Vector2) -> void:
	if _preview == null:
		return
	_preview.position = local_px
	_preview.visible = _preview is SymbolPreview and (active_brush != null and active_brush.symbol != null)
	_preview.queue_redraw()

func _update_preview_appearance() -> void:
	if _preview == null: 
		return
	if _preview is SymbolPreview:
		var sp := _preview as SymbolPreview
		sp.tex = (active_brush.symbol if active_brush and active_brush.symbol else null)
		sp.scale_factor = symbol_scale
		sp.brush = active_brush
		sp.queue_redraw()

func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		_hover_idx = _pick_point(event.position)
		if _is_drag and _drag_idx >= 0:
			if not render.is_inside_terrain(event.position):
				return false
			if event.position.is_finite():
				var local_m := editor.map_to_terrain(event.position)
				_set_point_pos(_drag_idx, local_m)
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_terrain(event.position):
				return false

			_hover_idx = _pick_point(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = (data.points[_drag_idx].duplicate(true) if _drag_idx >= 0 and _drag_idx < data.points.size() else {})
			else:
				if active_brush == null or active_brush.feature_type != TerrainBrush.FeatureType.POINT:
					return true
				if event.position.is_finite():
					var local_m := editor.map_to_terrain(event.position)
					_add_point(local_m)
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _drag_idx < data.points.size() and _drag_before.size() > 0:
				var after: Dictionary = data.points[_drag_idx].duplicate(true)
				if after != _drag_before:
					var id: int = after.get("id", null)
					if id != null:
						editor.history.push_item_edit_by_id(data, "points", id, _drag_before, after, "Move point")
			_drag_idx = -1
			_drag_before = {}
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _hover_idx >= 0:
					_remove_point(_hover_idx)
					_hover_idx = -1
				return true
			KEY_ESCAPE:
				_is_drag = false
				_drag_idx = -1
				return true

	return false

func _ensure_surfaces():
	if data == null: 
		return
	if !("surfaces" in data) or data.points == null:
		data.points = []

func _add_point(local_m: Vector2) -> void:
	if data == null: 
		return
	_ensure_surfaces()
	var pid := randi()
	var surf := {
		"id": pid,
		"brush": active_brush,
		"pos": local_m,
		"scale": symbol_scale
	}
	data.points.append(surf)
	editor.history.push_item_insert(data, "points", surf, "Add point", data.points.size())
	_emit_data_changed()

func _set_point_pos(idx_in_points: int, local_m: Vector2) -> void:
	if data == null or idx_in_points < 0 or idx_in_points >= data.points.size():
		return
	var s: Dictionary = data.points[idx_in_points]
	if s.get("type","") != "point":
		return
	s["pos"] = local_m
	data.points[idx_in_points] = s
	_emit_data_changed()

func _remove_point(idx_in_points: int) -> void:
	if data == null or idx_in_points < 0 or idx_in_points >= data.points.size():
		return
	var s: Dictionary = data.points[idx_in_points]
	var id = s.get("id", null)
	if id == null: 
		return
	var copy := s.duplicate(true)
	editor.history.push_item_erase_by_id(data, "points", id, copy, "Delete point", idx_in_points)
	data.points.remove_at(idx_in_points)
	_emit_data_changed()

func _pick_point(mouse_global: Vector2) -> int:
	if data == null or data.points == null:
		return -1
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px
	for i in data.points.size():
		var s = data.points[i]
		if typeof(s) != TYPE_DICTIONARY: 
			continue
		var p_local: Vector2 = s.get("pos", Vector2.INF)
		if not p_local.is_finite(): 
			continue
		var p_map := editor.map_to_terrain(p_local)
		var d2 := p_map.distance_squared_to(mouse_global)
		if d2 <= best_d2:
			best = i
			best_d2 = d2
	return best

func _emit_data_changed() -> void:
	if data == null: 
		return
	if data.has_method("emit_changed"): data.emit_changed()
	elif data.has_signal("changed"):    data.emit_signal("changed")

func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l

func _queue_free_children(node: Control):
	for n in node.get_children(): n.queue_free()

class SymbolPreview extends Control:
	var tex: Texture2D
	var brush: TerrainBrush
	var scale_factor := 1.0
	var antialias := true

	func _get_minimum_size() -> Vector2:
		if tex == null: 
			return Vector2.ZERO
		return Vector2(tex.get_width(), tex.get_height()) * max(0.01, scale_factor)

	func _draw() -> void:
		if tex == null:
			return
		var sc: float = max(0.01, scale_factor)
		var t_size: Vector2 = Vector2(brush.symbol_size_m, brush.symbol_size_m) * sc
		var top_left := -t_size * 0.5
		draw_texture_rect(tex, Rect2(top_left, t_size), false)
