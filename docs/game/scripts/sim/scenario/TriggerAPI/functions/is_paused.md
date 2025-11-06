# TriggerAPI::is_paused Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 32–37)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_paused() -> bool
```

- **Return Value**: True if simulation is paused.

## Description

Check if simulation is paused.

## Source

```gdscript
func is_paused() -> bool:
	if sim:
		return sim.get_state() == SimWorld.State.PAUSED
	return false
```
