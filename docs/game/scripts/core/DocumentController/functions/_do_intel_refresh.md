# DocumentController::_do_intel_refresh Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 755–762)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_intel_refresh() -> void
```

## Description

Debounced refresh functions - called after timer expires

## Source

```gdscript
func _do_intel_refresh() -> void:
	if _intel_viewport:
		_intel_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_intel_material, _intel_viewport)
```
