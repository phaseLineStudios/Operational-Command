# DocumentController::_do_briefing_refresh Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 716–721)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_briefing_refresh() -> void
```

## Source

```gdscript
func _do_briefing_refresh() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_briefing_material, _briefing_viewport)
```
