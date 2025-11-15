# DocumentController::_setup_viewports Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 114–141)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _setup_viewports() -> void
```

## Description

Setup SubViewports for each document

## Source

```gdscript
func _setup_viewports() -> void:
	var render_size := Vector2i(DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE)

	# Intel viewport
	_intel_viewport = SubViewport.new()
	_intel_viewport.size = render_size
	_intel_viewport.transparent_bg = false
	_intel_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_intel_viewport.gui_disable_input = false
	add_child(_intel_viewport)

	# Transcript viewport
	_transcript_viewport = SubViewport.new()
	_transcript_viewport.size = render_size
	_transcript_viewport.transparent_bg = false
	_transcript_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_transcript_viewport.gui_disable_input = false
	add_child(_transcript_viewport)

	# Briefing viewport
	_briefing_viewport = SubViewport.new()
	_briefing_viewport.size = render_size
	_briefing_viewport.transparent_bg = false
	_briefing_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_briefing_viewport.gui_disable_input = false
	add_child(_briefing_viewport)
```
