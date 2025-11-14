# ScenarioTaskRunner::setup Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 38–53)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void
```

- **p_unit_id**: Unit index in ScenarioData.units.
- **ordered_tasks**: Runner-ready tasks in execution order.

## Description

Initialize this runner for a unit and its ordered task list.

## Source

```gdscript
func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void:
	unit_id = p_unit_id
	_queue = ordered_tasks.duplicate(true)
	_active = {}
	_paused = false
	_started_current = false
	_tasks_by_index.clear()
	for task in _queue:
		var idx := int(task.get("__src_index", -1))
		if idx < 0:
			continue
		if not _tasks_by_index.has(idx):
			_tasks_by_index[idx] = []
		(_tasks_by_index[idx] as Array).append(task)
```
