# TTSService::_ready Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 34–43)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_piper_path = _get_platform_binary()
	if _piper_path == "":
		LogService.warning("Could not find piper binary.", "TTSService.gd:_ready")
		return
	if not set_voice(model):
		return
	say("check")
```
