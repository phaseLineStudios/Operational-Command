# TTSService::_ready Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 42–46)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_is_initializing = true
	call_deferred("_initialize_async")
```
