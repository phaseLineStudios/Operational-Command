extends Control
## Modal dialog for displaying mission messages and events.
##
## Shows text content with an OK button, optionally pausing the simulation.
## Used by TriggerAPI to display narrative moments, objectives, and updates.
## Can display a line from the dialog to a position on the map.

## Emitted when the dialog is closed.
signal dialog_closed

## Color of positional circle
@export var pos_color: Color = Color(0.063, 0.078, 0.094, 0.75)
## Color of positional line
@export var pos_line_color: Color = Color(0.063, 0.078, 0.094, 0.75)

var _sim: SimWorld = null
var _was_paused: bool = false
var _should_unpause: bool = false
var _map_controller: MapController = null
var _position_m: Variant = null

@onready var _text_label: RichTextLabel = %DialogText
@onready var _ok_button: Button = %OkButton
@onready var _line_overlay: Control = $LineOverlay


func _ready() -> void:
	visible = false
	if _ok_button:
		_ok_button.pressed.connect(_on_ok_pressed)
	if _line_overlay:
		_line_overlay.draw.connect(_draw_line)
		_line_overlay.visible = false


## Show dialog with message text and optional pause
## [param text] Message text to display (supports BBCode)
## [param pause_game] If true, pauses simulation until dialog is dismissed
## [param sim_world] Reference to SimWorld for pause control
## [param position_m] Optional position on map (in meters) to draw a line to
## [param map_controller] Reference to MapController for position conversion
func show_dialog(
	text: String,
	pause_game: bool = false,
	sim_world: SimWorld = null,
	position_m: Variant = null,
	map_controller: MapController = null
) -> void:
	if _text_label:
		_text_label.text = text

	_sim = sim_world
	_should_unpause = false
	_position_m = position_m
	_map_controller = map_controller

	# Handle pause if requested
	if pause_game and _sim:
		_was_paused = (_sim.get_state() == SimWorld.State.PAUSED)
		if not _was_paused:
			_sim.pause()
			_should_unpause = true

	visible = true
	if _ok_button:
		_ok_button.grab_focus()

	# Update line overlay visibility
	if _line_overlay:
		_line_overlay.visible = (_position_m != null and _map_controller != null)
		if _line_overlay.visible:
			_line_overlay.queue_redraw()


## Hide dialog and optionally resume game
func hide_dialog() -> void:
	visible = false

	# Hide line overlay
	if _line_overlay:
		_line_overlay.visible = false

	# Clear position and map controller references
	_position_m = null
	_map_controller = null

	# Resume if we paused it
	if _should_unpause and _sim:
		_sim.resume()
		_should_unpause = false

	dialog_closed.emit()


## Handle OK button press
func _on_ok_pressed() -> void:
	hide_dialog()


## Update line overlay every frame when visible
func _process(_delta: float) -> void:
	if _line_overlay and _line_overlay.visible:
		_line_overlay.queue_redraw()


## Draw the line from dialog to map position
func _draw_line() -> void:
	if not visible or _position_m == null or _map_controller == null:
		return

	# Get screen position of terrain location
	var map_screen_pos: Variant = _map_controller.terrain_to_screen(_position_m)
	if map_screen_pos == null:
		return

	# Get dialog center position (use the panel container's global rect)
	var panel := $CenterContainer/DialogPanel as Control
	if panel == null:
		return

	var dialog_rect := panel.get_global_rect()

	# Calculate closest point on dialog edge to the map position
	var start_pos := _get_closest_edge_point(dialog_rect, map_screen_pos)

	# Draw line from dialog edge to map position
	_line_overlay.draw_line(start_pos, map_screen_pos, pos_line_color, 2.0)

	# Draw a small circle at the map position
	_line_overlay.draw_circle(map_screen_pos, 5.0, pos_color)


## Get the closest point on the rectangle edge to a target position
func _get_closest_edge_point(rect: Rect2, target: Vector2) -> Vector2:
	var center := rect.get_center()

	# If target is inside rect, return center
	if rect.has_point(target):
		return center

	# Calculate intersection with rect edges
	var dx := target.x - center.x
	var dy := target.y - center.y

	if dx == 0.0 and dy == 0.0:
		return center

	# Find which edge the line from center to target intersects first
	var half_w := rect.size.x * 0.5
	var half_h := rect.size.y * 0.5

	# Time to reach each edge
	var t_x: float = INF if dx == 0.0 else half_w / abs(dx)
	var t_y: float = INF if dy == 0.0 else half_h / abs(dy)

	var t: float = min(t_x, t_y)
	return Vector2(center.x + dx * t, center.y + dy * t)
