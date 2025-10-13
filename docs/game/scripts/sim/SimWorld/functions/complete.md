# SimWorld::complete Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 257–261)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func complete() -> void
```

## Description

Complete mission.

## Source

```gdscript
func complete() -> void:
	if _state != State.COMPLETED:
		_transition(_state, State.COMPLETED)
```
