# TTSService::_initialize_async Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 43–63)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _initialize_async() -> void
```

## Description

Initialize TTS asynchronously to avoid blocking startup.

## Source

```gdscript
func _initialize_async() -> void:
	# Wait one frame to ensure UI has rendered
	await get_tree().process_frame

	_piper_path = _get_platform_binary()
	if _piper_path == "":
		LogService.warning("Could not find piper binary.", "TTSService.gd:_initialize_async")
		_is_initializing = false
		return

	LogService.info("Starting TTS initialization...", "TTSService.gd:_initialize_async")

	if not set_voice(model):
		_is_initializing = false
		return

	_initialization_complete = true
	_is_initializing = false
	LogService.info("TTS Service initialized successfully.", "TTSService.gd:_initialize_async")
```
