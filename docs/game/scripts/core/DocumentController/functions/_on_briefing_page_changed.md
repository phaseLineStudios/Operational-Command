# DocumentController::_on_briefing_page_changed Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 698–702)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _on_briefing_page_changed(page_index: int) -> void
```

## Source

```gdscript
func _on_briefing_page_changed(page_index: int) -> void:
	_display_page(_briefing_face, _briefing_content, _briefing_pages, page_index)
	_briefing_refresh_timer.start()
```
