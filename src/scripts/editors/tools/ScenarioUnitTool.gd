class_name UnitPlaceTool
extends ScenarioToolBase

@export var snap_to_grid := false

var payload
var _hover_map_pos := Vector2.ZERO
var _hover_valid := false
var _icon_tex: Texture2D


func _on_activated() -> void:
	if not payload:
		return
	if payload is UnitData:
		if editor.ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND:
			_icon_tex = payload.icon
		else:
			_icon_tex = payload.enemy_icon
	elif payload is UnitSlotData:
		_icon_tex = load("res://assets/textures/units/slot_icon.png") as Texture2D
	if _icon_tex == null:
		_icon_tex = (
			load(
				(
					"res://assets/textures/units/nato_unknown_platoon.png"
					if editor.ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND
					else "res://assets/textures/units/enemy_unknown_platoon.png"
				)
			)
			as Texture2D
		)
	emit_signal("request_redraw_overlay")


func _on_deactivated():
	if editor and editor.unit_list:
		editor.unit_list.deselect_all()
	emit_signal("request_redraw_overlay")


func build_hint_ui(parent: Control) -> void:
	_clear(parent)
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("RMB/ESC - Cancel"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Shift - Grid Snap"))


func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not editor or not editor.ctx or not editor.ctx.data or not editor.ctx.data.terrain:
		_hover_valid = false
		return false
	var mp := editor.terrain_render.map_to_terrain(e.position)
	if snap_to_grid or Input.is_key_pressed(KEY_SHIFT):
		mp = _snap(mp)
	_hover_map_pos = mp
	_hover_valid = editor.terrain_render.is_inside_map(mp)
	emit_signal("request_redraw_overlay")
	return true


func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if e.pressed:
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				if _hover_valid:
					_place()
					return true
			MOUSE_BUTTON_RIGHT:
				emit_signal("canceled")
				return true
	return false


func _on_key(e: InputEventKey) -> bool:
	if not e.pressed:
		return false
	if e.keycode == KEY_ESCAPE:
		emit_signal("canceled")
		return true
	return false


func draw_overlay(canvas: Control) -> void:
	if not _hover_valid or not _icon_tex:
		return
	var screen_pos := editor.ctx.terrain_render.terrain_to_map(_hover_map_pos)
	var size := Vector2(48, 48)
	var rect := Rect2(screen_pos - size * 0.5, size)
	canvas.draw_texture_rect(_icon_tex, rect, false)


func _place() -> void:
	if payload is UnitData:
		if _is_already_used(editor.ctx, payload):
			push_warning("That unit is already placed.")
			emit_signal("canceled")
			return

		editor._place_unit_from_tool(payload, _hover_map_pos)
		emit_signal("finished")
	elif payload is UnitSlotData:
		editor._place_slot_from_tool(payload, _hover_map_pos)
	else:
		emit_signal("finished")


func _snap(p: Vector2) -> Vector2:
	var s := 100.0
	return Vector2(round(p.x / s) * s, round(p.y / s) * s)


func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l


func _clear(node: Control) -> void:
	for c in node.get_children():
		c.queue_free()


func _is_already_used(ctx: ScenarioEditorContext, u: UnitData) -> bool:
	if ctx.data and ctx.data.units:
		for su: ScenarioUnit in ctx.data.units:
			if su and su.unit and String(su.unit.id) == String(u.id):
				return true
	return false
