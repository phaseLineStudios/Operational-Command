# MapController::_unhandled_input Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 65–74)</br>
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
	emit_signal("map_unhandled_mouse", event, res.map_px, res.terrain)
```
