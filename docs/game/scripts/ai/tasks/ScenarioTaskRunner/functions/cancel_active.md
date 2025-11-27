# ScenarioTaskRunner::cancel_active Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 70–74)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func cancel_active() -> void
```

## Description

Cancel the active task; the next tick will start the next queued task.

## Source

```gdscript
func cancel_active() -> void:
	_active.clear()
	_started_current = false
```
