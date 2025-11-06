# UnitCounterController::get_counter_count Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 87–90)</br>
*Belongs to:* [UnitCounterController](../../UnitCounterController.md)

**Signature**

```gdscript
func get_counter_count() -> int
```

- **Return Value**: Number of counters created.

## Description

Get the total number of counters created by the player.
Used by TriggerAPI to detect counter creation.

## Source

```gdscript
func get_counter_count() -> int:
	return _counter_count
```
