# ScenarioEditorMenus::open_task_config Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 84–90)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func open_task_config(task_index: int) -> void
```

- **task_index**: Task index.

## Description

Open task configuration dialog for a task index.

## Source

```gdscript
func open_task_config(task_index: int) -> void:
	if not editor.ctx.data or editor.ctx.data.tasks == null:
		return
	var inst: ScenarioTask = editor.ctx.data.tasks[task_index]
	editor.task_cfg.show_for(editor, inst)
```
