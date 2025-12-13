# SimWorld::_step_tick Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 190–217)</br>
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

	# Build alive unit lists once per tick
	var alive_friends: Array[ScenarioUnit] = []
	var alive_enemies: Array[ScenarioUnit] = []
	for su in _friendlies:
		if not su.is_dead():
			alive_friends.append(su)
	for su in _enemies:
		if not su.is_dead():
			alive_enemies.append(su)

	_process_orders()
	var moved_units := _update_movement(dt, alive_friends, alive_enemies)
	_update_logistics(dt)
	_update_los(alive_friends, alive_enemies, moved_units)
	_update_time(dt)
	_resolve_combat()
	_update_morale()
	_emit_events()
	_record_replay()
	_mission_complete_check(dt)

	trigger_engine.tick(dt)
	Game.resolution.tick(dt)
```
