# STTService::_process Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 76–102)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Description

Pull audio from the capture bus and feed Vosk in small chunks.

## Source

```gdscript
func _process(_dt: float) -> void:
	if not _recording or _effect == null:
		return

	var frames := _effect.get_frames_available()
	if frames <= 0:
		return

	var to_read: int = min(frames, 2048)
	var stereo_buffer: PackedVector2Array = _effect.get_buffer(to_read)

	var accepted := _stt.accept_wave_form_stereo_float(stereo_buffer)
	if accepted:
		var raw := _stt.result()
		var text := _extract_final_text(raw)
		if text.length() > 0:
			_apply_final(text)
			_emit_partial()
	else:
		var p := _stt.partial_result()
		if p.length() > 0:
			var j: Dictionary = JSON.parse_string(p)
			if typeof(j) == TYPE_DICTIONARY and j.has("partial"):
				_update_partial_segment(String(j["partial"]))
				_emit_partial()
```
