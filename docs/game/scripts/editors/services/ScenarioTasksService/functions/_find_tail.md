# ScenarioTasksService::_find_tail Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 135–143)</br>
*Belongs to:* [ScenarioTasksService](../../ScenarioTasksService.md)

**Signature**

```gdscript
func _find_tail(tasks: Array, unit_index: int) -> int
```

## Source

```gdscript
func _find_tail(tasks: Array, unit_index: int) -> int:
	var tail := -1
	for i in tasks.size():
		var ti: ScenarioTask = tasks[i]
		if ti and ti.unit_index == unit_index and ti.next_index == -1:
			tail = i
	return tail
```
