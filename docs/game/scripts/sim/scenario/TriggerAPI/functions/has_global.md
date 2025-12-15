# TriggerAPI::has_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 201–206)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_global(key: String) -> bool
```

- **key**: Variable name.
- **Return Value**: True if variable exists.

## Description

Check if a global variable exists.

## Source

```gdscript
func has_global(key: String) -> bool:
	if engine:
		return engine.has_global(key)
	return false
```
