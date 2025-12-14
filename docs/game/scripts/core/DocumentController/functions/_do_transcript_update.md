# DocumentController::_do_transcript_update Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 414–433)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_transcript_update() -> void
```

## Source

```gdscript
func _do_transcript_update() -> void:
	if _transcript_updating:
		_transcript_update_needs_rerun = true
		return

	_transcript_updating = true

	var was_on_last_page := false
	if _transcript_face and _transcript_pages.size() > 0:
		was_on_last_page = _transcript_face.current_page >= _transcript_pages.size() - 1

	await _update_transcript_content(was_on_last_page)

	_transcript_updating = false

	if _transcript_update_needs_rerun:
		_transcript_update_needs_rerun = false
		_queue_transcript_update()
```
