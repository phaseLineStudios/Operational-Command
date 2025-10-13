# SimWorld::_update_movement Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 140–148)</br>
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
	movement_adapter.tick_units(_friendlies, dt)
	movement_adapter.tick_units(_enemies, dt)
	for su in _friendlies + _enemies:
		emit_signal("unit_updated", su.id, _snapshot_unit(su))
```
