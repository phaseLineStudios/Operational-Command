# DocumentController::_apply_textures Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 436–444)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _apply_textures() -> void
```

## Description

Apply rendered textures to clipboard materials

## Source

```gdscript
func _apply_textures() -> void:
	await get_tree().process_frame
	await get_tree().process_frame  # Extra frame to ensure render complete

	_intel_material = _apply_texture_to_clipboard(intel_clipboard, _intel_viewport)
	_transcript_material = _apply_texture_to_clipboard(transcript_clipboard, _transcript_viewport)
	_briefing_material = _apply_texture_to_clipboard(briefing_clipboard, _briefing_viewport)
```
