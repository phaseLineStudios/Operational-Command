# EngineerController::tick Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 152–173)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func tick(delta: float) -> void
```

## Description

Tick active engineer tasks

## Source

```gdscript
func tick(delta: float) -> void:
	for i in range(_active_tasks.size() - 1, -1, -1):
		var task: EngineerTask = _active_tasks[i]

		var unit_pos: Vector2 = _positions.get(task.unit_id, Vector2.ZERO)
		var distance: float = unit_pos.distance_to(task.target_pos)

		if distance > required_proximity_m:
			continue

		task.time_elapsed += delta

		if not task.started:
			LogService.debug("Emitting task_started for %s" % task.unit_id, "EngineerController")
			emit_signal("task_started", task.unit_id, task.task_type, task.target_pos)
			task.started = true

		if task.time_elapsed >= task.duration:
			_process_completion(task)
			_active_tasks.remove_at(i)
```
