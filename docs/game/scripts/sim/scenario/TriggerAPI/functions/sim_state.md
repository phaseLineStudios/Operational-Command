# TriggerAPI::sim_state Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 55–70)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func sim_state() -> String
```

- **Return Value**: Current simulation state name.

## Description

Get simulation state as string ("INIT", "RUNNING", "PAUSED", "COMPLETED").

## Source

```gdscript
func sim_state() -> String:
	if not sim:
		return "INIT"
	match sim.get_state():
		SimWorld.State.INIT:
			return "INIT"
		SimWorld.State.RUNNING:
			return "RUNNING"
		SimWorld.State.PAUSED:
			return "PAUSED"
		SimWorld.State.COMPLETED:
			return "COMPLETED"
		_:
			return "UNKNOWN"
```
