# SimWorld::resume Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 499–503)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func resume() -> void
```

## Description

Resume simulation.

## Source

```gdscript
func resume() -> void:
	if _state == State.PAUSED:
		_transition(_state, State.RUNNING)
```
