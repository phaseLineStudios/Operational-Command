# DocumentController::_render_transcript_doc Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 331–358)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _render_transcript_doc() -> void
```

## Description

Render transcript document (initial render)

## Source

```gdscript
func _render_transcript_doc() -> void:
	# Header as atomic block during pagination (2 lines: title, subtitle)
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

	_transcript_pages = await _split_transcript_into_pages(
		_transcript_content, _transcript_full_content
	)
	# Show last page (most recent entries) for transcript
	var last_page: int = max(0, _transcript_pages.size() - 1)
	# Initialize face state
	_transcript_face.total_pages = _transcript_pages.size()
	_transcript_face.current_page = last_page
	_transcript_face.update_page_indicator()
	_display_page(_transcript_face, _transcript_content, _transcript_pages, last_page)
```
