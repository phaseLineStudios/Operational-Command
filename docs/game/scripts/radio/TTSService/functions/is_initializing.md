# TTSService::is_initializing Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 76–79)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func is_initializing() -> bool
```

- **Return Value**: True if initialization is in progress.

## Description

Check if TTS is currently initializing.

## Source

```gdscript
func is_initializing() -> bool:
	return _is_initializing
```
