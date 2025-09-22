extends Camera2D
class_name TerrainCamera

@export var pan_button: MouseButton = MOUSE_BUTTON_MIDDLE
@export var pan_speed: float = 1.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.25
@export var max_zoom: float = 4.0
@export var invert_pan: bool = false

var _panning := false
var _pan_cam_start: Vector2
var _pan_mouse_world_start: Vector2
var _delta_world: Vector2

func _ready() -> void:
	# Avoid anything that might fight direct positioning
	position_smoothing_enabled = false
	set_drag_horizontal_enabled(false)
	set_drag_vertical_enabled(false)

func _input(event: InputEvent) -> void:
	# Toggle panning and record anchors
	if event is InputEventMouseButton and event.button_index == pan_button:
		_panning = event.pressed
		if _panning:
			_pan_cam_start = position
			_pan_mouse_world_start = get_global_mouse_position()
			_delta_world = Vector2.ZERO
		return

	# Zoom at the cursor
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at_mouse(1.0 - zoom_step)
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at_mouse(1.0 + zoom_step)
			return

func _process(_dt: float) -> void:
	if !_panning:
		return
	# Absolute (anchor-based) world-space pan — no per-frame accumulation
	var now_world := get_global_mouse_position()
	_delta_world += _pan_mouse_world_start - now_world
	var dir := -1.0 if invert_pan else 1.0
	position = _pan_cam_start + dir * _delta_world * pan_speed

func _zoom_at_mouse(zoom_scale: float) -> void:
	# Maintain cursor-anchored zoom (works fine during a pan, too)
	var before := get_global_mouse_position()

	var new_zoom := zoom * zoom_scale
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom

	var after := get_global_mouse_position()
	position += (before - after)

	# If zooming while panning, re-anchor so there’s zero jitter
	if _panning:
		_pan_cam_start = position
		_pan_mouse_world_start = get_global_mouse_position()
