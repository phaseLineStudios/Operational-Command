# MovementAgent::_physics_process Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 58–91)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _physics_process(delta: float) -> void
```

## Source

```gdscript
func _physics_process(delta: float) -> void:
	if not _moving or _path.size() == 0:
		return

	_path_idx = clamp(_path_idx, 0, _path.size() - 1)

	var target := _path[_path_idx]
	var to_wp := target - sim_pos_m
	var dist := to_wp.length()

	if dist <= arrival_threshold_m:
		if _path_idx >= _path.size() - 1:
			_moving = false
			emit_signal("movement_arrived")
			return
		_path_idx += 1
		return

	var speed := _effective_speed_at(sim_pos_m)
	if speed <= 0.001:
		_moving = false
		emit_signal("movement_blocked", "blocked-cell")
		return

	var step: float = min(dist, speed * delta)
	var dir: Vector2 = to_wp / max(dist, 0.001)
	sim_pos_m += dir * step
	rotation = dir.angle()

	if debug_draw:
		_debug_push_trail()
		queue_redraw()
```
