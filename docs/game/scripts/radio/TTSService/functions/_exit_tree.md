# TTSService::_exit_tree Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 125–128)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Description

Stop stream thread to avoid hang on exit.

## Source

```gdscript
func _exit_tree() -> void:
	_tts.stop_stream()
```
