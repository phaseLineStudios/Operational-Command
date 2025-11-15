# ScenarioTaskRunner::block_task_index Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 187–194)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func block_task_index(idx: int, blocked: bool) -> void
```

## Description

Block or unblock tasks by their scenario source index.

## Source

```gdscript
func block_task_index(idx: int, blocked: bool) -> void:
	var tasks: Array = _tasks_by_index.get(idx, [])
	if tasks.is_empty():
		return
	for task in tasks:
		task["_blocked"] = blocked
	if not _active.is_empty() and int(_active.get("__src_index", -1)) == idx:
		_active["_blocked"] = blocked
```
