# ScenarioTasksService::make_task_title Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 115–119)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func make_task_title(inst: ScenarioTask, idx_in_chain: int) -> String
```

## Source

```gdscript
func make_task_title(inst: ScenarioTask, idx_in_chain: int) -> String:
	var nm := inst.task.display_name if (inst.task and inst.task.display_name != "") else "Task"
	return "%d: %s" % [idx_in_chain + 1, nm]
```
