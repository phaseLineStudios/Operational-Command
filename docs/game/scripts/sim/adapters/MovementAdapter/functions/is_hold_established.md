# MovementAdapter::is_hold_established Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 388–397)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func is_hold_established() -> bool
```

## Source

```gdscript
func is_hold_established() -> bool:
	# Established when inside radius and settled long enough
	if _actor == null:
		return true
	var inside: bool = (
		_actor.global_position.distance_to(_hold_center) <= _hold_radius + arrive_epsilon
	)
	return inside and _hold_timer >= hold_settle_time
```
