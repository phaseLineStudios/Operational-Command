extends TerrainToolBase
class_name TerrainLineTool

@export var active_brush: TerrainBrush
@export_range(0.5, 12.0, 0.5) var line_width_px: float = 2.0

var _info_ui_parent: Control

var _edit_id: int = -1
var _edit_idx: int = -1
var _drag_idx: int = -1
var _hover_idx: int = -1
var _is_drag := false
var _pick_radius_px := 10.0
var _next_id: int = randi()

func _init():
	tool_icon = preload("res://assets/textures/ui/editors_line_tool.png")
	tool_hint = "Line Tool"

func _load_brushes() -> void:
	brushes.clear()
	var dir := DirAccess.open("res://assets/terrain_brushes/")
	if dir:
		for f in dir.get_files():
			if f.ends_with(".tres") or f.ends_with(".res"):
				var r := ResourceLoader.load("res://assets/terrain_brushes/%s" % f)
				if r is TerrainBrush and r.feature_type == TerrainBrush.FeatureType.LINEAR:
					brushes.append(r)

func build_preview(parent: Node) -> Control:
	_preview = HandlesOverlay.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.anchor_left = 0; _preview.anchor_top = 0
	_preview.anchor_right = 1; _preview.anchor_bottom = 1
	_preview.offset_left = 0; _preview.offset_top = 0
	_preview.offset_right = 0; _preview.offset_bottom = 0
	(_preview as HandlesOverlay).tool = self
	parent.add_child(_preview)
	return _preview

func _place_preview(_local_px: Vector2) -> void:
	if _preview: _preview.queue_redraw()

func update_preview_at_overlay(_overlay: Control, _overlay_pos: Vector2):
	pass

func _queue_preview_redraw() -> void:
	if _preview: _preview.queue_redraw()

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

	var map_index := []
	for brush_idx in brushes.size():
		var brush: TerrainBrush = brushes[brush_idx]
		list.add_item(brush.legend_title)
		map_index.append(brush_idx)

	list.item_selected.connect(func(i):
		if i >= 0 and i < map_index.size():
			active_brush = brushes[map_index[i]]
			_sync_edit_brush_to_active_if_needed()
			_rebuild_info_ui()
	)
	vb.add_child(list)

	var s := HSlider.new()
	s.min_value = 0.5
	s.max_value = 12.0
	s.step = 0.5
	s.value = line_width_px
	s.value_changed.connect(func(v):
		line_width_px = v
		if _edit_idx >= 0:
			var surf: Dictionary = data.lines[_edit_idx]
			surf["width_px"] = line_width_px
			data.lines[_edit_idx] = surf
			_emit_data_changed()
	)
	vb.add_child(_label("Line width (px)"))
	vb.add_child(s)

func build_info_ui(parent: Control) -> void:
	_info_ui_parent = parent
	_rebuild_info_ui()

func _rebuild_info_ui():
	if not _info_ui_parent || not active_brush:
		return
	
	_queue_free_children(_info_ui_parent)
	var l = RichTextLabel.new()
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.bbcode_enabled = true
	l.text = "
	[b]Selected feature[/b] 
	%s
	
	[b]Movement Cost[/b]
	Foot: %d
	Wheeled: %d
	Tracked: %d
	Riverine: %d

	[b]LOS & Spotting[/b]
	Linear Attenuation: %d
	Spotting penalty (m): %d

	[b]Cover & Concealment[/b]
	Cover reduction: %d
	Concealment: %d

	[b]Special[/b]
	Road Bias: %d
	Bridge Capacity (t): %d
	" % [
		active_brush.legend_title,
		active_brush.mv_foot,
		active_brush.mv_wheeled,
		active_brush.mv_tracked,
		active_brush.mv_riverine,
		active_brush.los_attenuation_per_m,
		active_brush.spotting_penalty_m,
		active_brush.cover_reduction,
		active_brush.concealment,
		active_brush.road_bias,
		active_brush.bridge_capacity_tons
	]
	_info_ui_parent.add_child(l)

func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		if _edit_idx >= 0:
			_hover_idx = _pick_point(event.position)
			_queue_preview_redraw()
		if _is_drag and _drag_idx >= 0 and _edit_idx >= 0:
			var map_m: Vector2 = editor.screen_to_map(event.position, true)
			if not render.is_inside_terrain(map_m):
				return false

			if map_m.is_finite():
				var local_m := editor.terrain_to_map(map_m)
				var pts := _current_points()
				if _drag_idx >= 0 and _drag_idx < pts.size():
					pts[_drag_idx] = local_m
					_set_current_points(pts)
		return false
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var map_m: Vector2 = editor.screen_to_map(event.position, true)
			if not render.is_inside_terrain(map_m):
				return false

			if _edit_idx < 0:
				_start_new_line()
				_edit_idx = _find_edit_index_by_id()

			_hover_idx = _pick_point(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_queue_preview_redraw()
			else:
				if map_m.is_finite():
					_sync_edit_brush_to_active_if_needed()
					var local_m := editor.terrain_to_map(map_m)
					var pts := _current_points()
					pts.append(local_m)
					_set_current_points(pts)
					_queue_preview_redraw()
			return true
		else:
			_is_drag = false
			_drag_idx = -1
			_queue_preview_redraw()
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _edit_idx >= 0:
					var pts := _current_points()
					if pts.size() > 0:
						pts.remove_at(pts.size() - 1)
						_set_current_points(pts)
						_queue_preview_redraw()
				return true

			KEY_ENTER, KEY_KP_ENTER:
				if _edit_idx >= 0:
					var pts2 := _current_points()
					if pts2.size() < 2:
						_cancel_edit_delete_line()
					else:
						_finish_edit_keep_line()
					_queue_preview_redraw()
				return true

			KEY_ESCAPE:
				if _edit_idx >= 0:
					_cancel_edit_delete_line()
					_queue_preview_redraw()
				return true

	return false

func _start_new_line() -> void:
	if data == null: return
	if active_brush == null or active_brush.feature_type != TerrainBrush.FeatureType.LINEAR:
		return
	var pid := _next_id; _next_id += 1
	var line := {
		"id": pid,
		"brush": active_brush,
		"points": PackedVector2Array(),
		"closed": false,
		"width_px": line_width_px
	}
	data.lines.append(line)
	_edit_id = pid
	_edit_idx = data.lines.size() - 1
	_emit_data_changed()

func _current_points() -> PackedVector2Array:
	if data == null or _edit_idx < 0: return PackedVector2Array()
	return data.lines[_edit_idx].get("points", PackedVector2Array())

func _set_current_points(pts: PackedVector2Array) -> void:
	if data == null or _edit_idx < 0: return
	var s: Dictionary = data.lines[_edit_idx]
	s["points"] = pts
	data.lines[_edit_idx] = s
	_emit_data_changed()
	_queue_preview_redraw()

func _find_edit_index_by_id() -> int:
	if data == null or _edit_id < 0: return -1
	for i in data.lines.size():
		var s = data.lines[i]
		if "id" in s and int(s.id) == _edit_id:
			return i
	return -1

func _cancel_edit_delete_line() -> void:
	if data == null or _edit_idx < 0: return
	data.lines.remove_at(_edit_idx)
	_edit_id = -1; _edit_idx = -1
	_drag_idx = -1; _hover_idx = -1
	_is_drag = false
	_emit_data_changed()

func _finish_edit_keep_line() -> void:
	_edit_id = -1; _edit_idx = -1
	_drag_idx = -1; _hover_idx = -1
	_is_drag = false
	_emit_data_changed()

func _sync_edit_brush_to_active_if_needed() -> void:
	if data == null or _edit_idx < 0 or active_brush == null: return
	var s: Dictionary = data.lines[_edit_idx]
	if s.get("brush") != active_brush:
		s["brush"] = active_brush
		data.lines[_edit_idx] = s
		_emit_data_changed()

func _pick_point(pos: Vector2) -> int:
	var terrain_pos = editor.terrain_to_map(editor.screen_to_map(pos))
	if _edit_idx < 0: return -1
	var pts := _current_points()
	if pts.is_empty(): return -1
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px
	for i in pts.size():
		var d2 := pts[i].distance_squared_to(terrain_pos)
		if d2 <= best_d2:
			best = i
			best_d2 = d2
	return best

func _label(t: String) -> Label:
	var l := Label.new(); l.text = t; return l

func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()

func _emit_data_changed() -> void:
	if data == null: return
	if data.has_method("emit_changed"):
		data.emit_changed()
	elif data.has_signal("changed"):
		data.emit_signal("changed")

class HandlesOverlay extends Control:
	var tool: TerrainLineTool
	var handle_r := 7.0
	func _draw() -> void:
		if tool == null or tool._edit_idx < 0:
			return
		var pts := tool._current_points()
		if pts.is_empty():
			return

		for i in pts.size():
			var p_map := tool.editor.map_to_terrain(pts[i])

			draw_circle(p_map, handle_r + 2.0, Color(0,0,0,0.9))
			draw_circle(p_map, handle_r, Color(1,1,1,0.95))

		if tool._hover_idx >= 0 and tool._hover_idx < pts.size():
			var ph_map := tool.editor.map_to_terrain(pts[tool._hover_idx])
			draw_circle(ph_map, handle_r + 4.0, Color(1.0, 0.7, 0.2, 0.35))

		if tool._is_drag and tool._drag_idx >= 0 and tool._drag_idx < pts.size():
			var pd_map := tool.editor.map_to_terrain(pts[tool._drag_idx])
			draw_circle(pd_map, handle_r + 6.0, Color(0.2, 0.6, 1.0, 0.35))
