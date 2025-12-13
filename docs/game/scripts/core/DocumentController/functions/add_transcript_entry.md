# DocumentController::add_transcript_entry Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 385–412)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func add_transcript_entry(speaker: String, message: String) -> void
```

- **speaker**: Who is speaking (e.g., "PLAYER", "ALPHA", "HQ")
- **message**: The message text

## Description

Add a radio transmission to the transcript

## Source

```gdscript
func add_transcript_entry(speaker: String, message: String) -> void:
	var timestamp := _get_mission_timestamp()
	var entry := {"timestamp": timestamp, "speaker": speaker, "message": message}

	_transcript_entries.append(entry)

	if _transcript_entries.size() > MAX_TRANSCRIPT_ENTRIES:
		_transcript_entries.pop_front()

	if _transcript_updating:
		_transcript_pending_entries.append(entry)
		return

	_transcript_updating = true

	var was_on_last_page := false
	if _transcript_face and _transcript_pages.size() > 0:
		was_on_last_page = _transcript_face.current_page >= _transcript_pages.size() - 1

	await _update_transcript_content(was_on_last_page)

	_transcript_updating = false

	if _transcript_pending_entries.size() > 0:
		_transcript_pending_entries.clear()
		await _refresh_transcript_display()
```
