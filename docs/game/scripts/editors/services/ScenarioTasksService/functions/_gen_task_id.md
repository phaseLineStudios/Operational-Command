# ScenarioTasksService::_gen_task_id Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 120–134)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func _gen_task_id(ctx: ScenarioEditorContext, type_id: StringName) -> String
```

## Source

```gdscript
func _gen_task_id(ctx: ScenarioEditorContext, type_id: StringName) -> String:
	var base := "task_%s" % String(type_id)
	var used := {}
	if ctx.data.tasks:
		for t in ctx.data.tasks:
			if t and t.id is String and (t.id as String).begins_with(base + "_"):
				var s := (t.id as String).substr(base.length() + 1)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "%s_%d" % [base, n]
```
