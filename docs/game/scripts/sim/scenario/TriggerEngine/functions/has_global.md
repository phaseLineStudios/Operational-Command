# TriggerEngine::has_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 356–359)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

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
	return _globals.has(key)
```
