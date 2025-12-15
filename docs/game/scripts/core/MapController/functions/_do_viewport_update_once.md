# MapController::_do_viewport_update_once Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 270–276)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _do_viewport_update_once() -> void
```

## Source

```gdscript
func _do_viewport_update_once() -> void:
	_viewport_update_queued = false
	if terrain_viewport == null or _is_dynamic_viewport():
		return
	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
```
