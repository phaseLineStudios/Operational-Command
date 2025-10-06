# Radio::_stop_tx Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 57–65)</br>
*Belongs to:* [Radio](../Radio.md)

**Signature**

```gdscript
func _stop_tx() -> void
```

## Description

Manually disable the radio / STT.

## Source

```gdscript
func _stop_tx() -> void:
	if not _tx:
		return
	_tx = false
	STTService.stop()
	emit_signal("radio_off")
	LogService.info("PTT Released", "Radio.gd:58")
```
