# DocumentController::_do_briefing_refresh Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 771–778)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_briefing_refresh() -> void
```

## Source

```gdscript
func _do_briefing_refresh() -> void:
	if _briefing_viewport:
		_briefing_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_briefing_material, _briefing_viewport)
```
