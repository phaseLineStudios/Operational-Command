# MovementAdapter::_tick_patrol Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 467–493)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _tick_patrol(dt: float) -> void
```

## Source

```gdscript
func _tick_patrol(dt: float) -> void:
	if not _moving:
		# dwell on point before next leg
		if _patrol_dwell < patrol_dwell_seconds:
			_patrol_dwell += dt
			return
		# advance to next patrol leg
		if _advance_patrol_leg():
			_patrol_dwell = 0.0
		else:
			# finished a single cycle
			if _patrol_loop_forever:
				# reset segments and continue
				var n: int = _patrol_points.size()
				_patrol_segments_remaining = n if not _patrol_ping_pong else max(2 * n - 2, 1)
				_patrol_forward = true
				_patrol_index = wrapi(_patrol_index, 0, max(n, 1))
				_patrol_dwell = 0.0
				# re-enter on next frame
				return
			_patrol_running = false
			return
	# move step
	_step_move(dt)
	# when a leg finishes, _moving becomes false and dwell begins next frame
```
