# ScenarioTaskRunner::is_idle Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 55–58)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func is_idle() -> bool
```

## Description

True when there is no active task and the queue is empty.

## Source

```gdscript
func is_idle() -> bool:
	return _active.is_empty() and _queue.is_empty()
```
