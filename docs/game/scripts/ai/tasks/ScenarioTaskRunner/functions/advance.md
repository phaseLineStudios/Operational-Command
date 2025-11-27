# ScenarioTaskRunner::advance Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 76–80)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func advance() -> void
```

## Description

Force-skip the active task and begin the next one.

## Source

```gdscript
func advance() -> void:
	_active.clear()
	_started_current = false
```
