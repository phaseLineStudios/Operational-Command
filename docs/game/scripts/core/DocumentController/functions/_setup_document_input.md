# DocumentController::_setup_document_input Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 195–217)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _setup_document_input() -> void
```

## Description

Setup input forwarding from 3D documents to viewports

## Source

```gdscript
func _setup_document_input() -> void:
	if intel_clipboard:
		intel_clipboard.document_viewport = _intel_viewport
		intel_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		intel_clipboard.input_ray_pickable = true

	if transcript_clipboard:
		transcript_clipboard.document_viewport = _transcript_viewport
		transcript_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		transcript_clipboard.input_ray_pickable = true

	if briefing_clipboard:
		briefing_clipboard.document_viewport = _briefing_viewport
		briefing_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		briefing_clipboard.input_ray_pickable = true
```
