# Radio::_on_result Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 50–55)</br>
*Belongs to:* [Radio](../../Radio.md)

**Signature**

```gdscript
func _on_result(t)
```

## Description

Temporary for testing
TODO Remove this

## Source

```gdscript
func _on_result(t):
	LogService.trace("Heard: %s" % t, "Radio.gd:39")
	emit_signal("radio_raw_command", t)
	emit_signal("radio_result", t)
```
