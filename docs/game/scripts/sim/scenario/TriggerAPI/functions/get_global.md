# TriggerAPI::get_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 183–188)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_global(key: String, default: Variant = null) -> Variant
```

- **key**: Variable name.
- **default**: Default value if variable doesn't exist.
- **Return Value**: Variable value or default.

## Description

Get a global variable shared across all triggers.
Global variables persist across ticks and are visible to all triggers.

## Source

```gdscript
func get_global(key: String, default: Variant = null) -> Variant:
	if engine:
		return engine.get_global(key, default)
	return default
```
