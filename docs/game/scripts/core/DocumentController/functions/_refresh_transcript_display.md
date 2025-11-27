# DocumentController::_refresh_transcript_display Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 403–414)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _refresh_transcript_display() -> void
```

## Description

Refresh transcript display without adding new entries

## Source

```gdscript
func _refresh_transcript_display() -> void:
	_transcript_updating = true

	var was_on_last_page := false
	if _transcript_face and _transcript_pages.size() > 0:
		was_on_last_page = _transcript_face.current_page >= _transcript_pages.size() - 1

	await _update_transcript_content(was_on_last_page)

	_transcript_updating = false
```
