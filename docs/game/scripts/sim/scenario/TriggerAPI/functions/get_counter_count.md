# TriggerAPI::get_counter_count Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 355–360)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_counter_count() -> int
```

- **Return Value**: Number of counters created.

## Description

Get the number of unit counters the player has created.
  
  

**Usage in trigger condition:**

## Source

```gdscript
func get_counter_count() -> int:
	if _counter_controller and _counter_controller.has_method("get_counter_count"):
		return _counter_controller.get_counter_count()
	return 0
```
