# TriggerAPI::has_called_artillery Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 497–500)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_called_artillery() -> bool
```

- **Return Value**: True if at least one artillery mission has been called.

## Description

Check if any artillery fire missions have been called.
Returns true if at least one artillery mission has been requested.

## Source

```gdscript
func has_called_artillery() -> bool:
	return _artillery_called > 0
```
