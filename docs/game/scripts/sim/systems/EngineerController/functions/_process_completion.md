# EngineerController::_process_completion Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 176–195)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _process_completion(task: EngineerTask) -> void
```

- **tasl**: Engineer Task.

## Description

Process task completion

## Source

```gdscript
func _process_completion(task: EngineerTask) -> void:
	emit_signal("task_completed", task.unit_id, task.task_type, task.target_pos)

	match task.task_type.to_lower():
		"bridge", "build_bridge":
			_place_bridge(task.target_pos)
		"mine", "lay_mine":
			_place_mines(task.target_pos)
		"demo", "demolition":
			_place_demo(task.target_pos)

	LogService.info(
		(
			"Engineer task completed: %s finished %s at %s"
			% [task.unit_id, task.task_type, task.target_pos]
		),
		"EngineerController"
	)
```
