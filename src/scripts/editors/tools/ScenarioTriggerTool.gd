extends ScenarioToolBase
class_name ScenarioTriggerTool

@export var icon_px := 40

var prototype: ScenarioTrigger
var _hover_valid := false
var _hover_map_pos := Vector2.ZERO


func _on_activated() -> void:
	emit_signal("request_redraw_overlay")


func _on_deactivated():
	if editor and editor.trigger_list:
		editor.trigger_list.deselect_all()
	emit_signal("request_redraw_overlay")


func build_hint_ui(parent: Control) -> void:
	_clear(parent)
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("RMB/ESC - Cancel"))


func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not editor or not editor.ctx or not editor.ctx.data or not editor.ctx.data.terrain:
		_hover_valid = false
		return false
	_hover_map_pos = editor.terrain_render.map_to_terrain(e.position)
	_hover_valid = editor.terrain_render.is_inside_map(_hover_map_pos)
	emit_signal("request_redraw_overlay")
	return true


func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e.pressed:
		return false
	match e.button_index:
		MOUSE_BUTTON_LEFT:
			if _hover_valid and prototype:
				var inst := ScenarioTrigger.new()
				inst.title = prototype.title
				inst.presence = prototype.presence
				inst.area_shape = prototype.area_shape
				inst.area_size_m = prototype.area_size_m
				inst.require_duration_s = prototype.require_duration_s
				inst.condition_expr = prototype.condition_expr
				inst.on_activate_expr = prototype.on_activate_expr
				inst.on_deactivate_expr = prototype.on_deactivate_expr
				editor._place_trigger_from_tool(inst, _hover_map_pos)
				editor._clear_tool()
				emit_signal("finished")
				return true
		MOUSE_BUTTON_RIGHT:
			editor._clear_tool()
			emit_signal("canceled")
			return true
	return false


func _on_key(e: InputEventKey) -> bool:
	if e.pressed and e.keycode == KEY_ESCAPE:
		editor._clear_tool()
		emit_signal("canceled")
		return true
	return false


func draw_overlay(canvas: Control) -> void:
	if not _hover_valid or not prototype:
		return
	var center_px := editor.terrain_render.terrain_to_map(_hover_map_pos)
	var col := Color(Color.LIGHT_SKY_BLUE, 0.25)
	var outline := Color(Color.DEEP_SKY_BLUE, 0.9)
	var size_m := prototype.area_size_m

	if prototype.area_shape == ScenarioTrigger.AreaShape.CIRCLE:
		var r_m: float = max(size_m.x, size_m.y) * 0.5
		var edge_px := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(r_m, 0.0))
		var r_px := edge_px.distance_to(center_px)
		canvas.draw_circle(center_px, r_px, col)
		canvas.draw_arc(center_px, r_px, 0.0, TAU, 64, outline, 2.0, true)
	else:
		var hx_m := size_m.x * 0.5
		var hy_m := size_m.y * 0.5
		var p_x := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(hx_m, 0.0))
		var p_y := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(0.0, hy_m))
		var half_w_px: float = abs(p_x.x - center_px.x)
		var half_h_px: float = abs(p_y.y - center_px.y)
		var rect := Rect2(
			Vector2(center_px.x - half_w_px, center_px.y - half_h_px), Vector2(half_w_px * 2.0, half_h_px * 2.0)
		)
		canvas.draw_rect(rect, col, true)
		canvas.draw_rect(rect, outline, false, 2.0)


func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l


func _clear(node: Control) -> void:
	for c in node.get_children():
		c.queue_free()
