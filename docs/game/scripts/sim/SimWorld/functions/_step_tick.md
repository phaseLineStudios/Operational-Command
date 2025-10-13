# SimWorld::_step_tick Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 119–131)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _step_tick(dt: float) -> void
```

- **dt**: Tick delta seconds.

## Description

Executes a single sim tick (deterministic order).

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

	Game.resolution.tick(dt)
```
