# DocumentController::_queue_transcript_update Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 402–413)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _queue_transcript_update() -> void
```

## Source

```gdscript
func _queue_transcript_update() -> void:
	if _transcript_update_timer == null:
		return
	if _transcript_updating:
		_transcript_update_needs_rerun = true
		return
	_transcript_update_timer.wait_time = maxf(transcript_update_delay_sec, 0.01)
	if not _transcript_update_timer.is_stopped():
		return
	_transcript_update_timer.start()
```
