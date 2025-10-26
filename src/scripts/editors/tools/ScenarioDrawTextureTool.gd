class_name DrawTextureTool
extends ScenarioToolBase
## Texture-stamp tool for ScenarioEditor.
## Places a textured stamp at clicked position.

## Active texture.
@export var texture: Texture2D
## Stamp Color.
@export var color: Color = Color(0, 0, 0)
## Uniform scale.
@export_range(0.05, 10.0, 0.01) var scale: float = 1.0
## Rotation in degrees.
@export_range(-360.0, 360.0, 0.1) var rotation_deg: float = 0.0
## Opacity [0..1].
@export_range(0.0, 1.0, 0.01) var opacity: float = 1.0
## Optional text label shown to the right of the stamp.
@export var label: String = ""

var texture_path: String = ""
var _hover_m := Vector2.ZERO
var _has_hover := false


## Activate tool.
func _on_activated() -> void:
	request_redraw_overlay.emit()


## Deactivate tool.
func _on_deactivated() -> void:
	_has_hover = false
	request_redraw_overlay.emit()


## Handle mouse move.
## [param e] InputEventMouseMotion.
## [return] true if consumed.
func _on_mouse_move(e: InputEventMouseMotion) -> bool:
	if not texture:
		return false
	_hover_m = editor.ctx.terrain_render.map_to_terrain(e.position)
	_has_hover = true
	request_redraw_overlay.emit()
	return true


## Handle mouse button.
## [param e] InputEventMouseButton.
## [return] true if consumed.
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not texture:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		_place()
		return true
	return false


## Handle key/wheel: Q/E rotate, MouseWheel scale, R reset.
## [param e] InputEventKey|InputEventMouseButton.
## [return] true if consumed.
func _on_key(e: InputEventKey) -> bool:
	if e.pressed:
		match e.keycode:
			KEY_Q:
				rotation_deg -= 5.0
			KEY_E:
				rotation_deg += 5.0
			KEY_R:
				rotation_deg = 0.0
				scale = 1.0
		request_redraw_overlay.emit()
		return true
	return false


## Draw overlay preview.
## [param canvas] Overlay control.
func draw_overlay(canvas: Control) -> void:
	if not texture or not _has_hover:
		return
	var pos_px := editor.ctx.terrain_render.terrain_to_map(_hover_m)
	var sz := texture.get_size() * scale * 0.1
	var col := Color(1, 1, 1, opacity)
	col *= color
	canvas.draw_set_transform(pos_px, deg_to_rad(rotation_deg))
	var rect := Rect2(-sz * 0.5, sz)
	canvas.draw_texture_rect(texture, rect, false, col)
	canvas.draw_set_transform(Vector2(0, 0))


## Commit a stamp.
func _place() -> void:
	var st := ScenarioDrawingStamp.new()
	st.id = editor.draw_tools.next_drawing_id("stamp")
	st.texture_path = texture_path
	st.modulate = color
	st.opacity = opacity
	st.position_m = _hover_m
	st.scale = scale * 0.1
	st.rotation_deg = rotation_deg
	st.label = label
	st.order = Time.get_ticks_usec()
	if editor.ctx.data.drawings == null:
		editor.ctx.data.drawings = []
	editor.history.push_res_insert(editor.ctx.data, "drawings", "id", st, "Place Stamp")
	editor.ctx.request_overlay_redraw()
