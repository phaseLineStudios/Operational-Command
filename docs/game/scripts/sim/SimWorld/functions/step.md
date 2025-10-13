# SimWorld::step Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 251–255)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func step() -> void
```

## Description

Step one tick while paused.

## Source

```gdscript
func step() -> void:
	if _state == State.PAUSED:
		_step_tick(_tick_dt)
```
