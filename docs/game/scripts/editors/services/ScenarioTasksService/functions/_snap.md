# ScenarioTasksService::_snap Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 144–148)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func _snap(ctx: ScenarioEditorContext) -> Dictionary
```

## Source

```gdscript
func _snap(ctx: ScenarioEditorContext) -> Dictionary:
	return {
		"tasks":
		ScenarioHistory._deep_copy_array_res(ctx.data.tasks if ctx.data and ctx.data.tasks else [])
	}
```
