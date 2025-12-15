# TriggerAPI::is_running Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 41–46)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_running() -> bool
```

- **Return Value**: True if simulation is running.

## Description

Check if simulation is running.

## Source

```gdscript
func is_running() -> bool:
	if sim:
		return sim.get_state() == SimWorld.State.RUNNING
	return false
```
