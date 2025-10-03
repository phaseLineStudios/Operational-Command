extends Node
class_name ScenarioToolBase
## Base class for editor tools (units, triggers, tasks, etc.).
##
## Tools receive overlay input and can draw a preview overlay.

## Editor this tool is running under.
var editor: ScenarioEditor
var terrain: TerrainData

## Emit when the overlay should redraw
@warning_ignore("unused_signal")
signal request_redraw_overlay
## Emit when tool finished normally
@warning_ignore("unused_signal")
signal finished
## Emit when tool cancelled
@warning_ignore("unused_signal")
signal canceled


## Called by the editor when tool becomes active
func activate(ed: ScenarioEditor) -> void:
	editor = ed
	_on_activated()


## Called when tool is removed
func deactivate() -> void:
	_on_deactivated()
	editor = null


## Editor forwards overlay input here
func handle_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		return _on_mouse_move(event)
	elif event is InputEventMouseButton:
		return _on_mouse_button(event)
	elif event is InputEventKey:
		return _on_key(event)

	return false


## Called from overlay _draw(). Override to draw tool visuals
func draw_overlay(_canvas: Control) -> void:
	pass


## Short usage hint for the bottom bar
func build_hint_ui(_parent: Control) -> void:
	pass


func _on_activated() -> void:
	pass


func _on_deactivated() -> void:
	pass


func _on_mouse_move(_e: InputEventMouseMotion) -> bool:
	return false


func _on_mouse_button(_e: InputEventMouseButton) -> bool:
	return false


func _on_key(_e: InputEventKey) -> bool:
	return false
