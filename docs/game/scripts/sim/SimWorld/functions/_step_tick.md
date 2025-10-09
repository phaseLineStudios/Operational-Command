# SimWorld::_step_tick Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 113–123)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _step_tick(dt: float) -> void
```

## Description

Executes a single sim tick (deterministic order).
[param dt] Tick delta seconds.

## Source

```gdscript
func _step_tick(dt: float) -> void:
	_tick_idx += 1
	_process_orders()
	_update_movement(dt)
	_update_los()
	_resolve_combat()
	_update_morale()
	_emit_events()
	_record_replay()
```
