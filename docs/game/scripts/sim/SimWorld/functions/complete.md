# SimWorld::complete Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 367–371)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func complete(_failed: bool) -> void
```

## Description

Complete mission.

## Source

```gdscript
func complete(_failed: bool) -> void:
	if _state != State.COMPLETED:
		_transition(_state, State.COMPLETED)
```
