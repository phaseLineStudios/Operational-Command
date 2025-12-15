# TriggerAPI::has_created_counter Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 345–350)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_created_counter() -> bool
```

- **Return Value**: True if player has created at least one counter.

## Description

Check if the player has created any unit counters.
Returns true if at least one counter has been spawned.
  
  

**Usage in trigger condition:**

## Source

```gdscript
func has_created_counter() -> bool:
	if _counter_controller and _counter_controller.has_method("get_counter_count"):
		return _counter_controller.get_counter_count() > 0
	return false
```
