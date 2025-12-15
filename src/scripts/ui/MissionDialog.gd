extends Control
## Modal dialog for displaying mission messages and events.
##
## Shows text content with an OK button, optionally pausing the simulation.
## Used by TriggerAPI to display narrative moments, objectives, and updates.
## Can display a line from the dialog to a position on the map or to a UI node (for tutorials).

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
var _target_node: Variant = null  # Node or NodePath to point at
var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO

@onready var _text_label: RichTextLabel = %DialogText
@onready var _ok_button: Button = %OkButton
@onready var _line_overlay: Control = $LineOverlay
@onready var _drag_bar: Control = $CenterContainer/DialogPanel/DialogRoot/DragBar
@onready var _center_container: CenterContainer = $CenterContainer


func _ready() -> void:
	visible = false
	if _ok_button:
		_ok_button.pressed.connect(_on_ok_pressed)
	if _line_overlay:
		_line_overlay.draw.connect(_draw_line)
		_line_overlay.visible = false

	# Setup drag functionality
	if _drag_bar:
		_drag_bar.gui_input.connect(_on_drag_bar_input)
		_drag_bar.mouse_filter = Control.MOUSE_FILTER_STOP


## Show dialog with message text and optional pause
## [param text] Message text to display (supports BBCode)
## [param pause_game] If true, pauses simulation until dialog is dismissed
## [param sim_world] Reference to SimWorld for pause control
## [param position_m] Optional position on map (in meters) to draw a line to
## [param map_controller] Reference to MapController for position conversion
## [param target_node] Optional node or node path to point at (for tutorials)
func show_dialog(
	text: String,
	pause_game: bool = false,
	sim_world: SimWorld = null,
	position_m: Variant = null,
	map_controller: MapController = null,
	target_node: Variant = null
) -> void:
	if _text_label:
		_text_label.text = text

	_sim = sim_world
	_should_unpause = false
	_position_m = position_m
	_map_controller = map_controller
	_target_node = target_node

	# Handle pause if requested
	if pause_game and _sim:
		_was_paused = (_sim.get_state() == SimWorld.State.PAUSED)
		if not _was_paused:
			_sim.pause()
			_should_unpause = true

	visible = true
	if _ok_button:
		_ok_button.grab_focus()

	# Reset to centered position when showing
	if _center_container:
		_center_container.anchors_preset = Control.PRESET_CENTER
		_center_container.set_anchors_preset(Control.PRESET_CENTER)

	# Update line overlay visibility (show if we have either position or target node)
	if _line_overlay:
		var has_map_pos := _position_m != null and _map_controller != null
		var has_target_node := _target_node != null
		_line_overlay.visible = has_map_pos or has_target_node
		if _line_overlay.visible:
			_line_overlay.queue_redraw()


## Hide dialog and optionally resume game
func hide_dialog() -> void:
	visible = false

	# Hide line overlay
	if _line_overlay:
		_line_overlay.visible = false

	# Clear position, node, and map controller references
	_position_m = null
	_map_controller = null
	_target_node = null

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


## Draw the line from dialog to map position or target node
func _draw_line() -> void:
	if not visible:
		return

	var target_screen_pos: Variant = null

	# Priority 1: Target node (for tutorials)
	if _target_node != null:
		var node: Node = null
		if _target_node is String:
			# Try to find node by unique name first (%NodeName)
			if _target_node.begins_with("%"):
				node = get_node_or_null(_target_node)
			# Then try as a regular path
			if node == null:
				node = get_node_or_null(_target_node)
			# Finally try searching from root
			if node == null and get_tree():
				node = get_tree().root.find_child(_target_node.trim_prefix("%"), true, false)
		elif _target_node is NodePath:
			node = get_node_or_null(_target_node)
		elif _target_node is Node:
			node = _target_node

		if node and node is Control:
			# For Control nodes, use global rect center
			target_screen_pos = (node as Control).get_global_rect().get_center()
		elif node and node is Node2D:
			# For Node2D, use global position
			target_screen_pos = (node as Node2D).global_position
		elif node and node is Node3D:
			# For Node3D, try to get viewport position (may not always work)
			var cam := get_viewport().get_camera_3d()
			if cam:
				target_screen_pos = cam.unproject_position((node as Node3D).global_position)

	# Priority 2: Map position
	if target_screen_pos == null and _position_m != null and _map_controller != null:
		target_screen_pos = _map_controller.terrain_to_screen(_position_m)

	# If we don't have a valid target, bail out
	if target_screen_pos == null:
		return

	# Get dialog center position (use the panel container's global rect)
	var panel := $CenterContainer/DialogPanel as Control
	if panel == null:
		return

	var dialog_rect := panel.get_global_rect()

	# Calculate closest point on dialog edge to the target position
	var start_pos := _get_closest_edge_point(dialog_rect, target_screen_pos)

	# Draw line from dialog edge to target position
	_line_overlay.draw_line(start_pos, target_screen_pos, pos_line_color, 2.0)

	# Draw a small circle at the target position
	_line_overlay.draw_circle(target_screen_pos, 5.0, pos_color)


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


## Handle drag bar input for dragging the dialog
func _on_drag_bar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				# Start dragging
				_dragging = true
				_drag_offset = _center_container.global_position - get_global_mouse_position()
			else:
				# Stop dragging
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		# Update dialog position while dragging
		if _center_container:
			# Switch to manual positioning
			_center_container.set_anchors_preset(Control.PRESET_TOP_LEFT)
			_center_container.position = get_global_mouse_position() + _drag_offset
