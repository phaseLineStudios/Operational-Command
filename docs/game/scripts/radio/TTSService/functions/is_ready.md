# TTSService::is_ready Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 70–73)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func is_ready() -> bool
```

- **Return Value**: True if the Piper streaming process is running.

## Description

Check if TTS Service is ready.

## Source

```gdscript
func is_ready() -> bool:
	return _initialization_complete and _tts.is_stream_running()
```
