# SimWorld::_update_movement Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 191–207)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _update_movement(dt: float) -> void
```

## Description

Advances movement for all sides and emits unit snapshots.

## Source

```gdscript
func _update_movement(dt: float) -> void:
	if movement_adapter == null:
		return
	var alive_friends: Array[ScenarioUnit] = []
	var alive_enemies: Array[ScenarioUnit] = []
	for su in _friendlies:
		if not su.is_dead():
			alive_friends.append(su)
	for su in _enemies:
		if not su.is_dead():
			alive_enemies.append(su)
	movement_adapter.tick_units(alive_friends, dt)
	movement_adapter.tick_units(alive_enemies, dt)
	for su in _friendlies + _enemies:
		emit_signal("unit_updated", su.id, _snapshot_unit(su))
```
