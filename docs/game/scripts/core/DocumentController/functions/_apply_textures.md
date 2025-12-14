# DocumentController::_apply_textures Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 459–475)</br>
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
	# Render each SubViewport once before capturing to textures.
	if _intel_viewport:
		_intel_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	if _transcript_viewport:
		_transcript_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	if _briefing_viewport:
		_briefing_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

	await get_tree().process_frame
	await get_tree().process_frame  # Extra frame to ensure render complete

	_intel_material = _apply_texture_to_clipboard(intel_clipboard, _intel_viewport)
	_transcript_material = _apply_texture_to_clipboard(transcript_clipboard, _transcript_viewport)
	_briefing_material = _apply_texture_to_clipboard(briefing_clipboard, _briefing_viewport)
```
