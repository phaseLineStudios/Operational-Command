# DocumentController::_setup_refresh_timers Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 164–193)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _setup_refresh_timers() -> void
```

## Description

Setup debounce timers for texture refresh

## Source

```gdscript
func _setup_refresh_timers() -> void:
	# Intel timer
	_intel_refresh_timer = Timer.new()
	_intel_refresh_timer.wait_time = REFRESH_DELAY
	_intel_refresh_timer.one_shot = true
	_intel_refresh_timer.timeout.connect(_do_intel_refresh)
	add_child(_intel_refresh_timer)

	# Transcript timer
	_transcript_refresh_timer = Timer.new()
	_transcript_refresh_timer.wait_time = REFRESH_DELAY
	_transcript_refresh_timer.one_shot = true
	_transcript_refresh_timer.timeout.connect(_do_transcript_refresh)
	add_child(_transcript_refresh_timer)

	# Transcript update timer (coalesce new entries)
	_transcript_update_timer = Timer.new()
	_transcript_update_timer.wait_time = maxf(transcript_update_delay_sec, 0.01)
	_transcript_update_timer.one_shot = true
	_transcript_update_timer.timeout.connect(_do_transcript_update)
	add_child(_transcript_update_timer)

	# Briefing timer
	_briefing_refresh_timer = Timer.new()
	_briefing_refresh_timer.wait_time = REFRESH_DELAY
	_briefing_refresh_timer.one_shot = true
	_briefing_refresh_timer.timeout.connect(_do_briefing_refresh)
	add_child(_briefing_refresh_timer)
```
