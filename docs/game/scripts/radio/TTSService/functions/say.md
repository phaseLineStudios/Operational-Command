# TTSService::say Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 141–151)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func say(text: String) -> bool
```

- **text**: The text to speak.
- **Return Value**: True if speaking started.

## Description

Generate a TTS response (async).

## Source

```gdscript
func say(text: String) -> bool:
	if not _tts.is_stream_running():
		return false
	emit_signal("speaking_started", text)
	_is_speaking = true
	_audio_started = false  # Reset, will be set when we detect audio generation
	_last_buffer_fill = 0.0  # Don't start timer yet
	LogService.trace("speaking started", "TTSService.gd:say")
	return _tts.say_stream(text)
```
