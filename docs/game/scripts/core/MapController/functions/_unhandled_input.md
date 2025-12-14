# MapController::_unhandled_input Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 154–172)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Description

Handle *unhandled* input and emit when it hits the map.

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouse):
		return
	var mouse := (event as InputEventMouse).position
	var res: Variant = screen_to_map_and_terrain(mouse)
	if res == null:
		return
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).pressed
		and (event as InputEventMouseButton).double_click
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
	):
		_open_map_read_overlay()
		get_viewport().set_input_as_handled()
		return
	emit_signal("map_unhandled_mouse", event, res.map_px, res.terrain)
```
