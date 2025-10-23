class_name DrawEraserTool
extends ScenarioToolBase
## Eraser tool for ScenarioEditor.
## Click on drawings to delete them.

## Eraser radius in pixels for visual feedback.
@export var cursor_radius_px: float = 10.0
## Color for eraser cursor.
@export var cursor_color: Color = Color(1.0, 0.3, 0.3, 0.6)

var _mouse_pos_px := Vector2.ZERO


## Activate tool.
func _on_activated() -> void:
	request_redraw_overlay.emit()


## Deactivate tool.
func _on_deactivated() -> void:
	request_redraw_overlay.emit()


## Handle mouse move.
## [param e] InputEventMouseMotion.
## [return] true if consumed.
func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not e:
		return false
	_mouse_pos_px = e.position
	request_redraw_overlay.emit()
	return false


## Handle mouse button - erase drawing on click.
## [param e] InputEventMouseButton.
## [return] true if consumed.
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e or editor.ctx.data == null:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		var clicked_m := editor.ctx.terrain_render.map_to_terrain(e.position)
		var erased := _find_and_erase_drawing(clicked_m, e.position)
		if erased:
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


## Draw overlay preview (eraser cursor).
## [param canvas] Overlay control.
func draw_overlay(canvas: Control) -> void:
	canvas.draw_circle(_mouse_pos_px, cursor_radius_px, cursor_color)
	canvas.draw_arc(_mouse_pos_px, cursor_radius_px, 0.0, TAU, 32, Color.WHITE, 2.0, true)


## Find and erase a drawing near the click position.
## [param pos_m] Click position in terrain space.
## [param pos_px] Click position in screen space.
## [return] true if a drawing was erased.
func _find_and_erase_drawing(pos_m: Vector2, pos_px: Vector2) -> bool:
	if editor.ctx.data.drawings == null or editor.ctx.data.drawings.is_empty():
		return false

	# Check drawings in reverse order (topmost first)
	for i in range(editor.ctx.data.drawings.size() - 1, -1, -1):
		var drawing = editor.ctx.data.drawings[i]
		if drawing == null or not drawing.visible:
			continue

		var hit := false
		if drawing is ScenarioDrawingStroke:
			hit = _is_near_stroke(drawing, pos_m, pos_px)
		elif drawing is ScenarioDrawingStamp:
			hit = _is_near_stamp(drawing, pos_m, pos_px)

		if hit:
			# Delete this drawing via history (provide backup for undo)
			editor.history.push_res_erase_by_id(
				editor.ctx.data, "drawings", "id", drawing.id, drawing, "Erase Drawing", i
			)
			editor.ctx.request_overlay_redraw()
			return true

	return false


## Check if click is near a stroke.
## [param stroke] ScenarioDrawingStroke to check.
## [param pos_m] Click position in terrain space.
## [param pos_px] Click position in screen space.
## [return] true if near the stroke.
func _is_near_stroke(stroke: ScenarioDrawingStroke, _pos_m: Vector2, pos_px: Vector2) -> bool:
	if stroke.points_m.is_empty():
		return false

	var threshold_px: float = max(cursor_radius_px, stroke.width_px * 2.0)
	for i in range(1, stroke.points_m.size()):
		var p1_m := stroke.points_m[i - 1]
		var p2_m := stroke.points_m[i]
		var p1_px := editor.ctx.terrain_render.terrain_to_map(p1_m)
		var p2_px := editor.ctx.terrain_render.terrain_to_map(p2_m)

		# Distance from point to line segment
		var dist := _point_to_segment_distance(pos_px, p1_px, p2_px)
		if dist <= threshold_px:
			return true

	return false


## Check if click is near a stamp.
## [param stamp] ScenarioDrawingStamp to check.
## [param pos_m] Click position in terrain space.
## [param pos_px] Click position in screen space.
## [return] true if near the stamp.
func _is_near_stamp(stamp: ScenarioDrawingStamp, pos_m: Vector2, _pos_px: Vector2) -> bool:
	var dist := pos_m.distance_to(stamp.position_m)
	# Simple radius check - could be improved with actual stamp bounds
	var threshold_m: float = stamp.size_m.length() * 0.5
	return dist <= threshold_m


## Calculate distance from point to line segment.
## [param p] Point position.
## [param a] Line segment start.
## [param b] Line segment end.
## [return] Distance in pixels.
func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var ap := p - a
	var ab_len_sq := ab.length_squared()

	if ab_len_sq == 0.0:
		return ap.length()

	var t := clampf(ap.dot(ab) / ab_len_sq, 0.0, 1.0)
	var projection := a + ab * t
	return p.distance_to(projection)
