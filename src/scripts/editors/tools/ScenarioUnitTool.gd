extends ScenarioToolBase
class_name UnitPlaceTool
## Tool for placing a unit or a player slot.
##
## Hover shows a ghost. LMB places, ESC/RMB cancels.

## Payload: UnitData or UnitSlotData.
var payload

## Snap Unit to grid
@export var snap_to_grid := false
## Place multiple
@export var place_multiple := true

var _hover_map_pos := Vector2.ZERO
var _hover_valid := false
var _icon_tex: Texture2D

## Pick icon
func _on_activated() -> void:
	if not payload:
		return
	if payload is UnitData:
		_icon_tex = payload.icon
	elif payload is UnitSlotData:
		_icon_tex = load("res://assets/textures/units/slot_icon.png") as Texture2D
	if _icon_tex == null:
		_icon_tex = load("res://assets/textures/units/nato_unknown_platoon.png") as Texture2D
	emit_signal("request_redraw_overlay")

func _on_deactivated():
	editor.unit_list.deselect_all()
	emit_signal("request_redraw_overlay")

func build_hint_ui(parent: Control) -> void:
	editor._queue_free_children(parent)
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("RMB/ESC - Cancel"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Shift - Grid Snap"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Enter - Save"))
	pass

func _on_mouse_move(e: InputEventMouseMotion) -> void:
	if not editor or not editor.data or not editor.data.terrain:
		_hover_valid = false; return
	var mp := editor.terrain_render.map_to_terrain(e.position)
	if snap_to_grid or Input.is_key_pressed(KEY_SHIFT):
		mp = _snap(mp)
	_hover_map_pos = mp
	_hover_valid = editor.terrain_render.is_inside_map(mp)
	emit_signal("request_redraw_overlay")

func _on_mouse_button(e: InputEventMouseButton) -> void:
	if e.pressed:
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				if _hover_valid: _place()
			MOUSE_BUTTON_RIGHT:
				emit_signal("canceled")

func _on_key(e: InputEventKey) -> void:
	if not e.pressed: return
	if e.keycode == KEY_ESCAPE:
		emit_signal("canceled")

func draw_overlay(canvas: Control) -> void:
	## Draw ghost (scale at draw-time to avoid white quads).
	if not _hover_valid or not _icon_tex: return
	var screen_pos := editor.terrain_render.terrain_to_map(_hover_map_pos)
	var size := Vector2(48, 48)
	var rect := Rect2(screen_pos - size * 0.5, size)
	canvas.draw_texture_rect(_icon_tex, rect, false)

func _place() -> void:
	if payload is UnitData:
		editor._place_unit_from_tool(payload, _hover_map_pos)
	elif payload is UnitSlotData:
		editor._place_slot_from_tool(payload, _hover_map_pos)
	if place_multiple:
		pass # TODO Change tool hint in future
	else:
		emit_signal("finished"); editor.clear_tool()

func _snap(p: Vector2) -> Vector2:
	var s := 100.0
	return Vector2(round(p.x / s) * s, round(p.y / s) * s)


## Helper function to create a new label
func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l
