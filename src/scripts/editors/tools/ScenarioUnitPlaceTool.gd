extends ScenarioToolBase
class_name UnitPlaceTool
## Tool for placing a unit on the map.
##
## Hover shows a ghost. LMB places, ESC/RMB cancels. Q/E or wheel rotates.

var unit: UnitData

## Snap Unit to grid
@export var snap_to_grid := false
## Rotation step degrees
@export var rotate_step_deg := 15.0
## Place multiple
@export var place_multiple := true

var _hover_map_pos := Vector2.ZERO
var _hover_valid := false
var _icon_tex: Texture2D

func _on_activated() -> void:
	if not unit: 
		return
	_icon_tex = unit.icon
	if _icon_tex == null:
		_icon_tex = load("res://assets/textures/units/nato_unknown_platoon.png") as Texture2D
	emit_signal("request_redraw_overlay")
	emit_signal("hint_changed", get_hint_text())

func _on_deactivated():
	editor.unit_list.deselect_all()
	emit_signal("request_redraw_overlay")
	pass

func get_hint_text() -> String:
	return "LMB: place  •  RMB/ESC: cancel  •  Wheel/Q/E: rotate  •  Shift: snap toggle"

func _on_mouse_move(e: InputEventMouseMotion) -> void:
	if not editor or not editor.data or not editor.data.terrain:
		_hover_valid = false
		return
	var mp := editor.terrain_render.map_to_terrain(e.position)
	if snap_to_grid or Input.is_key_pressed(KEY_SHIFT):
		mp = _snap(mp)
	_hover_map_pos = mp
	_hover_valid = _inside_terrain(mp)
	emit_signal("request_redraw_overlay")

func _on_mouse_button(e: InputEventMouseButton) -> void:
	if e.pressed:
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				if _hover_valid:
					_place()
			MOUSE_BUTTON_RIGHT:
				emit_signal("canceled")

func _on_key(e: InputEventKey) -> void:
	if not e.pressed:
		return
	match e.keycode:
		KEY_ESCAPE:
			emit_signal("canceled")

func draw_overlay(canvas: Control) -> void:
	if not _hover_valid or not _icon_tex:
		return

	var screen_pos := editor.terrain_render.terrain_to_map(_hover_map_pos)
	var size := Vector2(48, 48)
	var rect := Rect2(screen_pos - size * 0.5, size)

	canvas.draw_texture_rect(_icon_tex, rect, false)

func _place() -> void:
	editor._place_unit_from_tool(unit, _hover_map_pos)
	if place_multiple:
		emit_signal("hint_changed", get_hint_text())
	else:
		emit_signal("finished")
		editor.clear_tool()

func _snap(p: Vector2) -> Vector2:
	var s := 100.0
	return Vector2(round(p.x / s) * s, round(p.y / s) * s)

func _inside_terrain(p: Vector2) -> bool:
	return editor.terrain_render.is_inside_map(p)
