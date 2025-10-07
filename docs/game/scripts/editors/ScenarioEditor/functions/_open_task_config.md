# ScenarioEditor::_open_task_config Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 244–250)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _open_task_config(task_index: int) -> void
```

## Description

Open task configuration dialog for a task index

## Source

```gdscript
func _open_task_config(task_index: int) -> void:
	if not ctx.data or ctx.data.tasks == null:
		return
	var inst: ScenarioTask = ctx.data.tasks[task_index]
	_task_cfg.show_for(self, inst)
```
