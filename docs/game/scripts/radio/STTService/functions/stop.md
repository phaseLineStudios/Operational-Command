# STTService::stop Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 59–74)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func stop() -> void
```

## Description

Stops streaming mic audio.

## Source

```gdscript
func stop() -> void:
	if not _recording:
		return
	_recording = false
	set_process(false)

	var raw := _stt.result()
	var tail := _extract_final_text(raw)
	if tail.length() > 0:
		_apply_final(tail)

	var full := _build_full_sentence()
	if full.length() > 0:
		emit_signal("result", full)
```
