# ScenarioUnit::resume_move Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 191–197)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func resume_move() -> void
```

## Description

Resume.

## Source

```gdscript
func resume_move() -> void:
	if _move_state == MoveState.PAUSED:
		_move_paused = false
		_move_state = MoveState.MOVING
		emit_signal("move_resumed")
```
