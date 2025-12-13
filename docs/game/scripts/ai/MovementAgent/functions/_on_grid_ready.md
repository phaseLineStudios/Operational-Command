# MovementAgent::_on_grid_ready Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 259–279)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _on_grid_ready(ready_profile: int) -> void
```

## Source

```gdscript
func _on_grid_ready(ready_profile: int) -> void:
	if grid == null or ready_profile != profile:
		return
	if _moving or _path.is_empty():
		return

	var target := _path[_path.size() - 1]
	if sim_pos_m.distance_to(target) <= arrival_threshold_m:
		# Already effectively at destination; just treat as arrived.
		_path.clear()
		emit_signal("movement_arrived")
		return

	var replanned := grid.find_path_m(sim_pos_m, target)
	if replanned.is_empty():
		emit_signal("movement_blocked", "grid-rebuilt-no-path")
		return

	_set_path(replanned)
```
