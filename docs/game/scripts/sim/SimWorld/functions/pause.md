# SimWorld::pause Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 239–243)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func pause() -> void
```

## Description

Pause simulation.

## Source

```gdscript
func pause() -> void:
	if _state == State.RUNNING:
		_transition(_state, State.PAUSED)
```
