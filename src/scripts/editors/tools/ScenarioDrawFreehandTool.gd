class_name DrawFreehandTool
extends ScenarioToolBase
## Freehand draw tool for ScenarioEditor.
## Draws a polyline while LMB is held.

## Current stroke color.
@export var color: Color = Color(0.9, 0.9, 0.2, 1.0)
## Stroke width in pixels.
@export var width_px: float = 3.0
## Opacity [0..1].
@export_range(0.0, 1.0, 0.01) var opacity: float = 1.0
## Minimum point spacing in meters to sample.
@export var min_step_m: float = 0.4

var _dragging := false
var _points_m: PackedVector2Array = []
var _last_m := Vector2.INF


## Activate tool.
func _on_activated() -> void:
	request_redraw_overlay.emit()


## Deactivate tool.
func _on_deactivated() -> void:
	_dragging = false
	_points_m.clear()
	request_redraw_overlay.emit()


## Handle mouse move.
## [param e] InputEventMouseMotion.
## [return] true if consumed.
func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not e:
		return false
	if _dragging and (e.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		var mp := editor.ctx.terrain_render.map_to_terrain(e.position)
		if not _last_m.is_finite() or mp.distance_to(_last_m) >= min_step_m:
			_points_m.push_back(mp)
			_last_m = mp
			request_redraw_overlay.emit()
		return true
	return false


## Handle mouse button.
## [param e] InputEventMouseButton.
## [return] true if consumed.
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e or editor.ctx.data == null:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		_dragging = true
		_points_m.clear()
		_last_m = Vector2.INF
		var mp := editor.ctx.terrain_render.map_to_terrain(e.position)
		_points_m.push_back(mp)
		_last_m = mp
		request_redraw_overlay.emit()
		return true
	if e.button_index == MOUSE_BUTTON_LEFT and not e.pressed and _dragging:
		_dragging = false
		_commit_if_valid()
		request_redraw_overlay.emit()
		return true
	return false


## Handle key events. ESC cancels.
## [param e] InputEventKey.
## [return] true if consumed.
func _on_key(e: InputEventKey) -> bool:
	if e.pressed and e.keycode == KEY_ESCAPE:
		emit_signal("canceled")
		return true
	return false


## Draw overlay preview.
## [param canvas] Overlay control.
func draw_overlay(canvas: Control) -> void:
	if _points_m.is_empty():
		return
	var pts_px := PackedVector2Array()
	for p_m in _points_m:
		pts_px.push_back(editor.ctx.terrain_render.terrain_to_map(p_m))
	var col := color
	col.a *= opacity
	for i in range(1, pts_px.size()):
		canvas.draw_line(pts_px[i - 1], pts_px[i], col, width_px, true)


## Commit current stroke.
func _commit_if_valid() -> void:
	if _points_m.size() < 2 or editor.ctx.data == null:
		return
	var st := ScenarioDrawingStroke.new()
	st.id = editor._next_drawing_id("stroke")
	st.color = color
	st.width_px = width_px
	st.opacity = opacity
	st.points_m = _points_m.duplicate()
	st.order = Time.get_ticks_usec()
	if editor.ctx.data.drawings == null:
		editor.ctx.data.drawings = []
	editor.history.push_res_insert(editor.ctx.data, "drawings", "id", st, "Draw Stroke")
	editor.ctx.request_overlay_redraw()
