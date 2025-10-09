# MovementAdapter::cancel_move Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 203–208)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func cancel_move(su: ScenarioUnit) -> void
```

## Description

Pauses current movement for a unit.
[param su] ScenarioUnit to pause.

## Source

```gdscript
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()
```
