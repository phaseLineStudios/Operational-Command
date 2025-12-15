# MapController::_sync_viewport_update_mode Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 252–261)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _sync_viewport_update_mode() -> void
```

## Description

Apply the correct SubViewport update mode for current settings.

## Source

```gdscript
func _sync_viewport_update_mode() -> void:
	if terrain_viewport == null:
		return
	if _is_dynamic_viewport():
		terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		_apply_viewport_texture()
		return
	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
```
