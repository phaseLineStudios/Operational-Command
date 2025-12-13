# ScenarioUnit::pause_move Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 183–189)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func pause_move() -> void
```

## Description

Pause.

## Source

```gdscript
func pause_move() -> void:
	if _move_state == MoveState.MOVING:
		_move_paused = true
		_move_state = MoveState.PAUSED
		emit_signal("move_paused")
```
