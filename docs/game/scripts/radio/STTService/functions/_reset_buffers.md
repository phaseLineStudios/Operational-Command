# STTService::_reset_buffers Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 114–120)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func _reset_buffers() -> void
```

## Description

Reset sentence buffers for a new recording session.

## Source

```gdscript
func _reset_buffers() -> void:
	_committed = ""
	_segment = ""
	_last_partial = ""
	_last_emitted = ""
```
