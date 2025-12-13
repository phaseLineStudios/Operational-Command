# DocumentController::_on_transcript_page_changed Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 704–708)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _on_transcript_page_changed(page_index: int) -> void
```

## Source

```gdscript
func _on_transcript_page_changed(page_index: int) -> void:
	_display_page(_transcript_face, _transcript_content, _transcript_pages, page_index)
	_transcript_refresh_timer.start()
```
