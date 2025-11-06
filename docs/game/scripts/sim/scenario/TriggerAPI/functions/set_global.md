# TriggerAPI::set_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 190–194)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func set_global(key: String, value: Variant) -> void
```

- **key**: Variable name.
- **value**: Value to store.

## Description

Set a global variable shared across all triggers.
Global variables persist across ticks and are visible to all triggers.

## Source

```gdscript
func set_global(key: String, value: Variant) -> void:
	if engine:
		engine.set_global(key, value)
```
