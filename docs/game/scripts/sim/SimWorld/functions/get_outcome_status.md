# SimWorld::get_outcome_status Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 560–563)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_outcome_status() -> String
```

- **Return Value**: `"in_progress"` or `"completed"`.

## Description

Outcome status string.

## Source

```gdscript
func get_outcome_status() -> String:
	return "in_progress" if _state in [State.INIT, State.RUNNING, State.PAUSED] else "completed"
```
