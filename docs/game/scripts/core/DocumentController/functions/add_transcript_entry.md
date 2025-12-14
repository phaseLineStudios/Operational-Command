# DocumentController::add_transcript_entry Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 437–448)</br>
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
	var timestamp: String = _get_mission_timestamp()
	var entry: Dictionary = {"timestamp": timestamp, "speaker": speaker, "message": message}

	_transcript_entries.append(entry)

	if _transcript_entries.size() > MAX_TRANSCRIPT_ENTRIES:
		_transcript_entries.pop_front()

	_queue_transcript_update()
```
