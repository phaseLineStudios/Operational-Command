# TTSService::set_voice Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 89–120)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func set_voice(new_model: Model) -> bool
```

- **new_model**: New model to use.
- **Return Value**: True if model switched, false if failed.

## Description

Set speaker voice model and restart streaming service.

## Source

```gdscript
func set_voice(new_model: Model) -> bool:
	var mdl := _get_model_path(new_model)
	if mdl.is_empty():
		LogService.warning("Could not find piper model.", "TTSService.gd:set_voice")
		return false

	_model_path = mdl.get("model", "")
	_config_path = mdl.get("config", "")
	_sample_rate = _read_sample_rate(_config_path, 22050)

	_gen = AudioStreamGenerator.new()
	_gen.mix_rate = _sample_rate
	_gen.buffer_length = buffer_length_sec

	emit_signal("stream_ready", _gen)
	call_deferred("emit_signal", "stream_ready", _gen)

	var ok := _tts.start_stream(
		_abs_path(_piper_path), _abs_path(_model_path), _abs_path(_config_path), _sample_rate
	)
	if not ok:
		LogService.error("Failed to start Piper streaming process.", "TTSService.gd:81")
		emit_signal("stream_error", "Failed to start Piper streaming process.")
		return false

	LogService.trace(
		"Streaming TTS started (%s @ %d Hz)" % [Model.keys()[new_model], _sample_rate],
		"TTSService.gd:set_voice"
	)
	return true
```
