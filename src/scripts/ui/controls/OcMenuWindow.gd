@tool
class_name OcMenuWindow
extends Control

## Emitted when the ok button is pressed.
signal ok_pressed()
## Emitted when the cancel button is pressed.
signal cancel_pressed()
## Emitted when the close button is pressed.
signal close_pressed()

## Title of window
@export var window_title: String = ""

var window: OCMenuContainer
var close_button: Button
var cancel_button: OCMenuButton
var ok_button: OCMenuButton
var _dragbar: HBoxContainer
var _title: Label

var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	window = %DialogPanel
	close_button = %CloseButton
	cancel_button = %CancelButton
	ok_button = %OkButton
	_dragbar = %DragBar
	_title = %Title
	
	_title.text = window_title
	
	close_button.pressed.connect(_close_pressed)
	cancel_button.pressed.connect(_cancel_pressed)
	ok_button.pressed.connect(_ok_pressed)
	_dragbar.gui_input.connect(_on_dragbar_gui_input)

func _process(_dt: float) -> void:
	if Engine.is_editor_hint():
		%Title.text = window_title


## Show dialog without changing position.
func popup() -> void:
	visible = true
	move_to_front()
	grab_focus()

## Show dialog centered in parent Control or viewport.
func popup_centered() -> void:
	visible = true
	move_to_front()
	grab_focus()

	var ref_size := _get_reference_rect_size()
	var current_size := size

	if current_size == Vector2.ZERO:
		current_size = custom_minimum_size
		if current_size == Vector2.ZERO:
			current_size = Vector2(300.0, 200.0)

	position = ((ref_size - current_size) * 0.5).round()


## Show dialog centered and sized to [param ratio] of parent/viewport.
## [param ratio] Size ratio relative to reference rect (0-1).
func popup_centered_ratio(ratio: float = 0.75) -> void:
	ratio = clampf(ratio, 0.0, 1.0)

	visible = true
	move_to_front()
	grab_focus()

	var ref_size := _get_reference_rect_size()
	var new_size := ref_size * ratio

	size = new_size
	position = ((ref_size - new_size) * 0.5).round()

## Emitts ok pressed event
func _ok_pressed() -> void:
	LogService.trace("OK Pressed", "OcMenuWindow.gd: 43")
	emit_signal("ok_pressed")

## Emitts ok pressed event
func _cancel_pressed() -> void:
	LogService.trace("Cancel Pressed", "OcMenuWindow.gd: 43")
	emit_signal("cancel_pressed")

## Emitts ok pressed event
func _close_pressed() -> void:
	LogService.trace("Close Pressed", "OcMenuWindow.gd: 43")
	emit_signal("close_pressed")

## Handles mouse input on the drag bar to drag the window.
## [param event] GUI input event from the drag bar.
func _on_dragbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton

		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				var parent_control := get_parent() as Control
				if parent_control != null:
					_is_dragging = true
					_drag_offset = parent_control.get_local_mouse_position() - position
				accept_event()
			else:
				_is_dragging = false
				accept_event()

	elif event is InputEventMouseMotion and _is_dragging:
		var mm := event as InputEventMouseMotion
		var parent_control := get_parent() as Control

		if parent_control != null:
			var mouse_parent := parent_control.get_local_mouse_position()
			position = (mouse_parent - _drag_offset).round()
		else:
			position += mm.relative.round()

		accept_event()


## Get size of parent Control if available, otherwise viewport size.
## [return] Reference rect size for centering.
func _get_reference_rect_size() -> Vector2:
	var parent_control := get_parent() as Control
	if parent_control != null:
		return parent_control.get_rect().size
	return get_viewport_rect().size
