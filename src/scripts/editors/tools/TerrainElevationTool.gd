@tool
extends TerrainToolBase
class_name TerrainElevationTool

## Elevation editing: raise/lower/smooth brush.

enum Mode { RAISE, LOWER, SMOOTH }
var mode: int = Mode.RAISE
var brush_radius_m := 80.0
var strength_m := 2.0

var _is_drag := false

## Assign Metadata
func _init():
	tool_icon = preload("res://assets/textures/ui/editors_elevation_tool.png")
	tool_hint = "Elevation Tool"

func build_options_ui(p: Control) -> void:
	var vb := VBoxContainer.new()
	p.add_child(vb)
	var lb := OptionButton.new()
	lb.add_item("Raise", Mode.RAISE)
	lb.add_item("Lower", Mode.LOWER)
	lb.add_item("Smooth", Mode.SMOOTH)
	lb.selected = mode
	lb.item_selected.connect(func(i): mode = i)
	vb.add_child(_label("Mode"))
	vb.add_child(lb)

	var r := HSlider.new()
	r.min_value = 5
	r.max_value = 200
	r.step = 1
	r.value = brush_radius_m
	r.value_changed.connect(func(v): brush_radius_m = v)
	vb.add_child(_label("Radius (m)"))
	vb.add_child(r)

	var s := HSlider.new()
	s.min_value = 0.1
	s.max_value = 10
	s.step = 0.1
	s.value = strength_m
	s.value_changed.connect(func(v): strength_m = v)
	vb.add_child(_label("Strength (m)"))
	vb.add_child(s)

func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l

func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			_is_drag = true
			_apply(event.position)
		else:
			_is_drag = false
		return true
	if _is_drag and event is InputEventMouseMotion:
		_apply(event.position); return true
	return false

func _apply(_screen_pos: Vector2) -> void:
	# TODO create logic for drawing elevation
	pass
