# TriggerEngine::get_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 324–327)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func get_global(key: String, default: Variant = null) -> Variant
```

- **key**: Variable name.
- **default**: Default value if variable doesn't exist.
- **Return Value**: Variable value or default.

## Description

Get a global variable value shared across all triggers.

## Source

```gdscript
func get_global(key: String, default: Variant = null) -> Variant:
	return _globals.get(key, default)
```
