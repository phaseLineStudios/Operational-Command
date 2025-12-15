# DocumentController::_do_transcript_refresh Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 763–770)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_transcript_refresh() -> void
```

## Source

```gdscript
func _do_transcript_refresh() -> void:
	if _transcript_viewport:
		_transcript_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_transcript_material, _transcript_viewport)
```
