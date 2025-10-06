# Radio::_start_tx Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 47–55)</br>
*Belongs to:* [Radio](../Radio.md)

**Signature**

```gdscript
func _start_tx() -> void
```

## Description

Manually enable the radio / STT.

## Source

```gdscript
func _start_tx() -> void:
	if _tx:
		return
	LogService.info("PTT Pressed", "Radio.gd:46")
	_tx = true
	STTService.start()
	emit_signal("radio_on")
```
