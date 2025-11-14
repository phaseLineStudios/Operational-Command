# ScenarioTaskRunner::_start_next Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 83–98)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func _start_next() -> bool
```

- **Return Value**: True if a task was started.

## Description

Pop the next task (if unblocked) and emit task_started.

## Source

```gdscript
func _start_next() -> bool:
	if _queue.is_empty():
		_active = {}
		_started_current = false
		return false
	var candidate: Dictionary = _queue[0]
	if bool(candidate.get("_blocked", false)):
		_active = {}
		_started_current = false
		return false
	_active = _queue.pop_front()
	_started_current = false
	emit_signal("task_started", unit_id, StringName(_active.get("type", "unknown")))
	return true
```
