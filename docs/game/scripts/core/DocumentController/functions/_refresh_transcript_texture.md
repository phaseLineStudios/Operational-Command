# DocumentController::_refresh_transcript_texture Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 477–483)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _refresh_transcript_texture() -> void
```

## Description

Refresh the transcript document texture after content updates

## Source

```gdscript
func _refresh_transcript_texture() -> void:
	if _transcript_material and _transcript_viewport:
		_transcript_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		await get_tree().process_frame  # Wait for render
		_refresh_texture(_transcript_material, _transcript_viewport)
```
