# TTSService::_process Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 146–149)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Description

Pull bytes from the extension and push frames (if playback registered).

## Source

```gdscript
func _process(_dt: float) -> void:
	_tts.pump()
```
