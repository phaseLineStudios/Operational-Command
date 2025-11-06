# TriggerAPI::has_created_counter Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 338–343)</br>
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

```
# Trigger activates when player has created a counter
has_created_counter()

# Combined with other conditions
has_created_counter() and time_s() > 30
```

## Source

```gdscript
func has_created_counter() -> bool:
	if _counter_controller and _counter_controller.has_method("get_counter_count"):
		return _counter_controller.get_counter_count() > 0
	return false
```
