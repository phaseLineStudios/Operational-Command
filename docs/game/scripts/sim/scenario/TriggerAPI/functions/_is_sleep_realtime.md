# TriggerAPI::_is_sleep_realtime Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 580–583)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _is_sleep_realtime() -> bool
```

- **Return Value**: True if sleep_ui was called, false if sleep was called.

## Description

Check if sleep uses realtime (internal use by TriggerVM).

## Source

```gdscript
func _is_sleep_realtime() -> bool:
	return _sleep_use_realtime
```
