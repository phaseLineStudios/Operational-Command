# MapController::_update_mouse_grid_ui Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 523–540)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _update_mouse_grid_ui() -> void
```

## Description

Grid hover label update

## Source

```gdscript
func _update_mouse_grid_ui() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		_grid_label.visible = false
		return
	var mouse := get_viewport().get_mouse_position()
	var res: Variant = screen_to_map_and_terrain(mouse)
	if res == null:
		if _grid_label:
			_grid_label.visible = false
		return
	var grid: String = renderer.pos_to_grid(res.terrain)
	emit_signal("mouse_grid_changed", res.terrain, grid)
	if _grid_label:
		_grid_label.get_node("Label").text = grid
		_grid_label.global_position = mouse + grid_label_offset
		_grid_label.visible = true
```
