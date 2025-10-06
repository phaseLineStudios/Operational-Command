# ScenarioTasksService::collect_unit_chain Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 93–114)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func collect_unit_chain(data: ScenarioData, unit_index: int) -> Array[int]
```

## Source

```gdscript
func collect_unit_chain(data: ScenarioData, unit_index: int) -> Array[int]:
	var out: Array[int] = []
	if data == null or data.tasks == null:
		return out
	var visited := {}
	for i in data.tasks.size():
		var t: ScenarioTask = data.tasks[i]
		if t and t.unit_index == unit_index and t.prev_index == -1:
			var cur := i
			while cur >= 0 and cur < data.tasks.size() and not visited.has(cur):
				visited[cur] = true
				out.append(cur)
				var nxt := data.tasks[cur].next_index
				if nxt == cur:
					break
				cur = nxt
	for j in data.tasks.size():
		if data.tasks[j] and data.tasks[j].unit_index == unit_index and not visited.has(j):
			out.append(j)
	return out
```
