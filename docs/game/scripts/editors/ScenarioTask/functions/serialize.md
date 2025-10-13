# ScenarioTask::serialize Function Reference

*Defined at:* `scripts/editors/ScenarioTask.gd` (lines 28–39)</br>
*Belongs to:* [ScenarioTask](../../ScenarioTask.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Convert this task into a JSON-safe dictionary

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"task_type": String(task.type_id) if task else "",
		"position_m": ContentDB.v2(position_m),
		"params": params,
		"unit_index": unit_index,
		"next_index": next_index,
		"prev_index": prev_index,
	}
```
