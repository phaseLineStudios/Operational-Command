# MovementAdapter::cancel_move Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 203–208)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func cancel_move(su: ScenarioUnit) -> void
```

- **su**: ScenarioUnit to pause.

## Description

Pauses current movement for a unit.

## Source

```gdscript
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()
```
