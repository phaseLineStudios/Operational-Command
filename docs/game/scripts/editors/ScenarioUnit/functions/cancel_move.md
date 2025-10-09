# ScenarioUnit::cancel_move Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 133–139)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func cancel_move() -> void
```

## Description

Cancel ongoing movement.

## Source

```gdscript
func cancel_move() -> void:
	_move_path = []
	_move_path_idx = 0
	_move_dest_m = position_m
	_move_state = MoveState.IDLE
```
