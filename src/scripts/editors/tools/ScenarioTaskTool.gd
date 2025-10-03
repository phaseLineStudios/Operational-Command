extends ScenarioToolBase
class_name TaskPlaceTool

@export var task: UnitBaseTask
@export var snap_to_grid := false

var _hover_map_pos := Vector2.ZERO
var _hover_valid := false


func build_hint_ui(parent: Control) -> void:
	_clear(parent)
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("RMB/ESC - Cancel"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Shift - Grid Snap"))


func _on_activated() -> void:
	emit_signal("request_redraw_overlay")


func _on_deactivated():
	if editor and editor.task_list:
		editor.task_list.deselect_all()
	emit_signal("request_redraw_overlay")


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
	if not e.pressed:
		return false
	match e.button_index:
		MOUSE_BUTTON_LEFT:
			if _hover_valid:
				_place()
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
	if not _hover_valid:
		return
	var p := editor.terrain_render.terrain_to_map(_hover_map_pos)
	canvas.draw_circle(p, 6.0, task.color if task else Color.CYAN)


func _place() -> void:
	if not editor or not editor.ctx:
		return
	if editor.ctx.selected_pick.is_empty():
		editor.ctx.toast("Select a unit or a task first.")
		return

	var unit_idx := -1
	var after_idx := -1

	match String(editor.ctx.selected_pick.get("type", "")):
		"unit":
			unit_idx = int(editor.ctx.selected_pick["index"])
		"task":
			after_idx = int(editor.ctx.selected_pick["index"])
			var sel: ScenarioTask = editor.ctx.data.tasks[after_idx]
			if sel == null:
				editor.ctx.toast("Selected task is invalid.")
				return
			unit_idx = sel.unit_index
		_:
			editor.ctx.toast("Select a unit or a task first.")
			return

	var new_idx := editor.tasks.place_task_for_unit(editor.ctx, unit_idx, task, _hover_map_pos, after_idx)
	if new_idx < 0:
		return
	emit_signal("request_redraw_overlay")


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
