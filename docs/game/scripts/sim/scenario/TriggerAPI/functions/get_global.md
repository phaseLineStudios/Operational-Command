# TriggerAPI::get_global Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 180–185)</br>
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
  
  

**Usage in trigger expressions:**

```
# In trigger A:
set_global("mission_phase", 2)

# In trigger B (can read what A wrote):
if get_global("mission_phase", 0) >= 2:
radio("Phase 2 started")
```

## Source

```gdscript
func get_global(key: String, default: Variant = null) -> Variant:
	if engine:
		return engine.get_global(key, default)
	return default
```
