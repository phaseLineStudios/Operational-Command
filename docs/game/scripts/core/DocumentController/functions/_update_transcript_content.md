# DocumentController::_update_transcript_content Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 340–381)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _update_transcript_content(follow_new_messages: bool) -> void
```

## Description

Update transcript content while preserving page position

## Source

```gdscript
func _update_transcript_content(follow_new_messages: bool) -> void:
	# Remember current page
	var old_page: int = _transcript_face.current_page if _transcript_face else 0

	# Rebuild content - header as atomic block during pagination (2 lines: title, subtitle)
	_transcript_full_content = "[center][b]RADIO TRANSCRIPT[/b]\n"
	_transcript_full_content += "Mission Communications Log[/center]\n\n"

	if _transcript_entries.is_empty():
		_transcript_full_content += "[i]No communications recorded.[/i]\n"
	else:
		for entry in _transcript_entries:
			var timestamp: String = entry.get("timestamp", "")
			var speaker: String = entry.get("speaker", "")
			var message: String = entry.get("message", "")

			_transcript_full_content += "[b]%s[/b] [%s]\n" % [timestamp, speaker]
			_transcript_full_content += "%s\n\n" % message

	# Re-paginate
	_transcript_pages = await _split_transcript_into_pages(
		_transcript_content, _transcript_full_content
	)
	_transcript_face.total_pages = _transcript_pages.size()

	# Choose which page to show
	var target_page: int
	if follow_new_messages:
		# User was on last page, follow new messages
		target_page = max(0, _transcript_pages.size() - 1)
	else:
		# User was reading old messages, stay on same page (or closest valid)
		target_page = clampi(old_page, 0, _transcript_pages.size() - 1)

	_transcript_face.current_page = target_page
	_transcript_face.update_page_indicator()
	_display_page(_transcript_face, _transcript_content, _transcript_pages, target_page)

	# Refresh texture immediately for transcript updates (no debounce needed)
	await _do_transcript_refresh()
```
