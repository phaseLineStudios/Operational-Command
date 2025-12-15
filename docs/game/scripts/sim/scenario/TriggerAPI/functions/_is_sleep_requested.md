# TriggerAPI::_is_sleep_requested Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 568–571)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _is_sleep_requested() -> bool
```

- **Return Value**: True if sleep was called.

## Description

Check if sleep was requested (internal use by TriggerVM).

## Source

```gdscript
func _is_sleep_requested() -> bool:
	return _sleep_requested
```
