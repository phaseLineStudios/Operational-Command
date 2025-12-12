# EnvBehaviorSystem::_emit_speed_change Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 217–226)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _emit_speed_change(unit_id: String, mult: float) -> void
```

## Description

Broadcast speed multiplier changes downstream.

## Source

```gdscript
func _emit_speed_change(unit_id: String, mult: float) -> void:
	var prev: float = _speed_mult_cache.get(unit_id, 1.0)
	if is_equal_approx(prev, mult):
		return
	_speed_mult_cache[unit_id] = mult
	if movement_adapter and movement_adapter.has_method("set_env_speed_multiplier"):
		movement_adapter.set_env_speed_multiplier(_find_unit_by_id(unit_id), mult)
	emit_signal("speed_modifier_changed", unit_id, mult)
```
