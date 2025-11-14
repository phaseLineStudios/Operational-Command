# MovementAdapter::_physics_process Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 89–105)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _physics_process(dt: float) -> void
```

## Source

```gdscript
func _physics_process(dt: float) -> void:
	if _actor == null:
		return

	# Patrol takes priority and drives _moving
	if _patrol_running:
		_tick_patrol(dt)

	# Move step
	if _moving:
		_step_move(dt)

	# Hold settle timer
	if _holding:
		_tick_hold(dt)
```
