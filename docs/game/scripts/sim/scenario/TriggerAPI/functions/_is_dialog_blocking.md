# TriggerAPI::_is_dialog_blocking Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 593–596)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _is_dialog_blocking() -> bool
```

- **Return Value**: True if waiting for dialog to close.

## Description

Check if dialog blocking is active (internal use by TriggerVM).

## Source

```gdscript
func _is_dialog_blocking() -> bool:
	return _dialog_blocking
```
