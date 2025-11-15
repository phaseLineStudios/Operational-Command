# MovementAdapter::_tick_hold Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 455–466)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _tick_hold(dt: float) -> void
```

## Source

```gdscript
func _tick_hold(dt: float) -> void:
	if _actor == null:
		return
	var inside: bool = (
		_actor.global_position.distance_to(_hold_center) <= _hold_radius + arrive_epsilon
	)
	if inside and not _moving:
		_hold_timer += dt
	else:
		_hold_timer = 0.0
```
