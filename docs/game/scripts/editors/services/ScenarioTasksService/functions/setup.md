# ScenarioTasksService::setup Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 8–13)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func setup(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func setup(ctx: ScenarioEditorContext) -> void:
	_init_defs()
	_build_list(ctx)
	ctx.task_list.item_selected.connect(func(idx): _on_selected(ctx, idx))
```
