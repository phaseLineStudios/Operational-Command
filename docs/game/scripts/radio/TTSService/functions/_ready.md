# TTSService::_ready Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 36–41)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Defer TTS initialization to avoid blocking game startup
	_is_initializing = true
	call_deferred("_initialize_async")
```
