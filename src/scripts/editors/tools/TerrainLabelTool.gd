extends TerrainToolBase
class_name TerrainLabelTool

@export var label_text: String = "Label"
@export var label_size: int = 16
@export var label_rotation_deg: float = 0.0

var _hover_idx := -1
var _drag_idx := -1
var _is_drag := false
var _drag_before: Dictionary = {}
var _pick_radius_px := 14.0


func _init():
	tool_icon = preload("res://assets/textures/ui/editors_label_tool.png")
	tool_hint = "Label Tool"


func build_preview(overlay_parent: Node) -> Control:
	_preview = LabelPreview.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.z_index = 100
	overlay_parent.add_child(_preview)
	_refresh_preview()
	return _preview


func _place_preview(local_px: Vector2) -> void:
	if _preview == null:
		return
	_preview.position = local_px
	_preview.visible = true
	_preview.queue_redraw()


func _refresh_preview() -> void:
	if _preview == null:
		return
	if _preview is LabelPreview:
		var p := _preview as LabelPreview
		p.text = label_text
		p.font = render.label_font
		p.font_size = label_size
		p.rot_deg = label_rotation_deg
		p.fill_color = render.label_color
		p.outline_color = Color(1, 1, 1, 1)
		p.queue_redraw()


func build_options_ui(parent: Control) -> void:
	var vb := VBoxContainer.new()
	parent.add_child(vb)

	vb.add_child(_label("Text"))
	var te := LineEdit.new()
	te.text = label_text
	te.text_changed.connect(
		func(t):
			label_text = t
			_refresh_preview()
	)
	vb.add_child(te)

	vb.add_child(_label("Font size"))
	var s := HSlider.new()
	s.min_value = 8
	s.max_value = 96
	s.step = 1
	s.value = label_size
	s.value_changed.connect(
		func(v):
			label_size = int(v)
			_refresh_preview()
	)
	vb.add_child(s)

	var rot_slider := HSlider.new()
	rot_slider.min_value = -180.0
	rot_slider.max_value = 180.0
	rot_slider.step = 1.0
	rot_slider.value = label_rotation_deg
	rot_slider.value_changed.connect(
		func(v):
			label_rotation_deg = v
			_refresh_preview()
	)
	vb.add_child(_label("Rotation (°)"))
	vb.add_child(rot_slider)


func build_info_ui(parent: Control) -> void:
	var l := Label.new()
	l.text = "Place text label"
	parent.add_child(l)


func build_hint_ui(parent: Control) -> void:
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Drag - Move"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Backspace - Delete hovered"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Esc - Cancel Drag"))


func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		_hover_idx = _pick_label(event.position)
		if _is_drag and _drag_idx >= 0:
			if not render.is_inside_terrain(event.position):
				return false

			if event.position.is_finite():
				var local_m := editor.map_to_terrain(event.position)
				_set_label_pos(_drag_idx, local_m)
		return false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not render.is_inside_terrain(event.position):
				return false

			_hover_idx = _pick_label(event.position)
			if _hover_idx >= 0:
				_is_drag = true
				_drag_idx = _hover_idx
				_drag_before = (
					data.labels[_drag_idx].duplicate(true) if _drag_idx >= 0 and _drag_idx < data.labels.size() else {}
				)
			else:
				if event.position.is_finite():
					var local_m := editor.map_to_terrain(event.position)
					_add_label(local_m, label_text, label_size)
			return true
		else:
			_is_drag = false
			if _drag_idx >= 0 and _drag_idx < data.labels.size() and _drag_before.size() > 0:
				var after: Dictionary = data.labels[_drag_idx].duplicate(true)
				if after != _drag_before:
					var id: int = after.get("id", null)
					if id != null:
						editor.history.push_item_edit_by_id(data, "labels", id, _drag_before, after, "Move label")
			_drag_idx = -1
			_drag_before = {}
			return true

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_BACKSPACE:
				if _hover_idx >= 0:
					_remove_label(_hover_idx)
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
	if !("surfaces" in data) or data.labels == null:
		data.labels = []


func _add_label(local_pos: Vector2, text: String, size: int) -> void:
	if data == null:
		return
	_ensure_surfaces()
	var label := {"id": randi(), "text": text, "pos": local_pos, "rot": label_rotation_deg, "size": size}
	data.add_label(label)
	editor.history.push_item_insert(data, "labels", label, "Add label", data.labels.size())


func _set_label_pos(idx: int, local_pos: Vector2) -> void:
	if data == null or idx < 0 or idx >= data.labels.size():
		return
	var d: Dictionary = data.labels[idx]
	data.set_label_pose(d.id, local_pos, label_rotation_deg)


func _remove_label(idx: int) -> void:
	if data == null or idx < 0 or idx >= data.labels.size():
		return
	var d: Dictionary = data.labels[idx]
	var id = d.get("id", null)
	if id == null:
		return
	var copy := d.duplicate(true)
	editor.history.push_item_erase_by_id(data, "labels", id, copy, "Delete label", idx)
	data.remove_label(id)


func _pick_label(mouse_global: Vector2) -> int:
	if data == null or data.labels == null:
		return -1
	var size := label_size
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px

	for i in data.labels.size():
		var s = data.labels[i]
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


func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l


func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()


class LabelPreview:
	extends Control
	var text: String = ""
	var font: Font
	var font_size: int = 16
	var rot_deg: float = 0.0
	var fill_color: Color = Color(0.1, 0.1, 0.1, 1.0)
	var outline_color: Color = Color(1, 1, 1, 1)

	func _draw() -> void:
		if font == null or text == "":
			return

		var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var ascent := font.get_ascent(font_size)
		var height := font.get_height(font_size)

		var baseline := Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)

		var ang := deg_to_rad(rot_deg)
		draw_set_transform(Vector2.ZERO, ang, Vector2.ONE)

		var offs := [
			Vector2(-1, 0),
			Vector2(1, 0),
			Vector2(0, -1),
			Vector2(0, 1),
			Vector2(-1, -1),
			Vector2(1, -1),
			Vector2(-1, 1),
			Vector2(1, 1)
		]
		for o in offs:
			draw_string(font, baseline + o, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, outline_color)
		draw_string(font, baseline, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, fill_color)

		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
