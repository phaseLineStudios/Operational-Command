# TTSService::_process Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 153–178)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Description

Pull bytes from the extension and push frames (if playback registered).

## Source

```gdscript
func _process(_dt: float) -> void:
	_tts.pump()

	if _is_speaking and _playback:
		var frames_available := _playback.get_frames_available()
		var buffer_size := _gen.buffer_length * _sample_rate

		# Detect when audio generation starts (buffer being filled)
		if not _audio_started and frames_available < buffer_size * 0.9:
			_audio_started = true
			_last_buffer_fill = Time.get_ticks_msec() / 1000.0
			LogService.trace("audio generation started", "TTSService.gd:_process")

		# Only check for completion after audio has started
		if _audio_started:
			if frames_available < buffer_size * 0.5:
				_last_buffer_fill = Time.get_ticks_msec() / 1000.0
			else:
				var current_time := Time.get_ticks_msec() / 1000.0
				if current_time - _last_buffer_fill >= _speaking_timeout:
					_is_speaking = false
					_audio_started = false
					emit_signal("speaking_finished")
					LogService.trace("speaking finished", "TTSService.gd:_process")
```
