# MapController::_request_map_refresh Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 361–374)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _request_map_refresh(with_mipmaps: bool) -> void
```

## Description

Request a one-shot viewport render and (optionally) a mipmap bake.

## Source

```gdscript
func _request_map_refresh(with_mipmaps: bool) -> void:
	if terrain_viewport == null or not is_inside_tree():
		return
	_sync_viewport_update_mode()
	if _is_dynamic_viewport():
		return

	# Show the live viewport immediately; bake mipmaps after changes settle.
	_apply_viewport_texture()
	_queue_viewport_update()
	if with_mipmaps and bake_viewport_mipmaps:
		_schedule_mipmap_update()
```
