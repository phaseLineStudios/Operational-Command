# MapController::_run_mipmap_update_async Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 315–327)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _run_mipmap_update_async(gen: int) -> void
```

## Source

```gdscript
func _run_mipmap_update_async(gen: int) -> void:
	if _is_dynamic_viewport() or terrain_viewport == null or not is_inside_tree():
		return

	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame

	if gen != _mipmap_gen:
		return
	_update_mipmap_texture()
```
