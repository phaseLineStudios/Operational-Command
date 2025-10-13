# STTService::_emit_partial Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 151–159)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func _emit_partial() -> void
```

## Description

Emit the current accumulated sentence as a partial update.

## Source

```gdscript
func _emit_partial() -> void:
	var full := _build_full_sentence()
	if full.length() == 0 or full == _last_emitted:
		return
	_last_emitted = full
	LogService.trace("Partial: %s" % full, "STTService.gd:146")
	emit_signal("partial", full)
```
