# TriggerEngine::set_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 328–331)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func set_global(key: String, value: Variant) -> void
```

- **key**: Variable name.
- **value**: Value to store.

## Description

Set a global variable value shared across all triggers.

## Source

```gdscript
func set_global(key: String, value: Variant) -> void:
	_globals[key] = value
```
