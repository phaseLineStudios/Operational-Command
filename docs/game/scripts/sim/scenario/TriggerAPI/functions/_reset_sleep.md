# TriggerAPI::_reset_sleep Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 758–763)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _reset_sleep() -> void
```

## Description

Reset sleep state (internal use by TriggerVM).

## Source

```gdscript
func _reset_sleep() -> void:
	_sleep_requested = false
	_sleep_duration = 0.0
	_sleep_use_realtime = false
```
