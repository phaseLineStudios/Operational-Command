extends Camera2D

@export var pan_button: MouseButton = MOUSE_BUTTON_MIDDLE
@export var pan_speed: float = 1.0             # Multiply to make drag feel faster/slower
@export var zoom_step: float = 0.1              # 0.1 = 10% per wheel notch
@export var min_zoom: float = 0.25              # Smaller = closer
@export var max_zoom: float = 4.0               # Larger  = farther
@export var invert_pan: bool = false

var _panning := false

func _input(event: InputEvent) -> void:
	# Start/stop panning with middle mouse
	if event is InputEventMouseButton and event.button_index == pan_button:
		_panning = event.pressed
		return

	# Zoom with mouse wheel (keep cursor anchored)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at_mouse(1.0 - zoom_step) # in
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at_mouse(1.0 + zoom_step) # out
			return

	# While panning, move opposite/same as mouse motion depending on invert_pan
	if event is InputEventMouseMotion and _panning:
		var dir := -1.0
		if invert_pan:
			dir = 1.0
		# Divide by zoom so drag speed stays consistent regardless of zoom level
		position += dir * (event.relative / zoom) * pan_speed

func _zoom_at_mouse(z_scale: float) -> void:
	# Keep the world point under the cursor fixed while zooming
	var mouse_world_before: Vector2 = get_global_mouse_position()

	var new_zoom := zoom * z_scale
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom

	var mouse_world_after: Vector2 = get_global_mouse_position()
	position += (mouse_world_before - mouse_world_after)
