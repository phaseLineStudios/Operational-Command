# STTService::start Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 50–57)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func start() -> void
```

## Description

Starts streaming mic audio into Vosk.

## Source

```gdscript
func start() -> void:
	if _recording:
		return
	_reset_buffers()
	_recording = true
	set_process(true)
```
