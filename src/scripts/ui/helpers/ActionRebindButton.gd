extends Button
## Simple action rebinding button.
##
## Click -> capture next input; ESC clears. Shows current binding.

## Action to rebind.
@export var action_name: String = ""

var _capturing := false

## Set action programmatically.
func set_action(new_name: String) -> void:
	action_name = new_name
	refresh_label()

## Update text from current binding.
func refresh_label() -> void:
	if action_name == "": text = "(unset)"; return
	var events := InputMap.action_get_events(action_name)
	text = events[0].as_text() if events.size() > 0 else "(unbound)"

func _ready() -> void:
	pressed.connect(_begin_capture)
	refresh_label()

## Enter capture mode.
func _begin_capture() -> void:
	_capturing = true
	text = "Press a key… (ESC to clear)"
	focus_mode = FOCUS_ALL
	grab_focus()

## Capture input and assign.
func _unhandled_input(event: InputEvent) -> void:
	if not _capturing: return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		# Clear binding
		InputMap.action_erase_events(action_name)
		_capturing = false
		refresh_label()
		accept_event()
		return

	if event.is_pressed():
		# Only allow one primary binding (simple).
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		_capturing = false
		refresh_label()
		accept_event()
