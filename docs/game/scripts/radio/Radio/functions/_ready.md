# Radio::_ready Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 18–23)</br>
*Belongs to:* [Radio](../../Radio.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Connect to STTService signals.

## Source

```gdscript
func _ready() -> void:
	STTService.partial.connect(func(t): emit_signal("radio_partial", t))
	STTService.result.connect(_on_result)
	STTService.error.connect(func(m): push_error("[Radio] STT error: %s" % m))
```
