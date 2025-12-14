# MapController::_process Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 139–152)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
	var dyn := _is_dynamic_viewport()
	if dyn != _dynamic_viewport_cached:
		_dynamic_viewport_cached = dyn
		_sync_viewport_update_mode()
		if not dyn:
			_request_map_refresh(true)
	var current_mouse := get_viewport().get_mouse_position()
	if current_mouse.distance_to(_last_mouse_pos) < 1.0:
		return
	_last_mouse_pos = current_mouse
	_update_mouse_grid_ui()
```
