# ScenarioEditor::_start_place_task_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 259–264)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _start_place_task_tool(task: UnitBaseTask) -> void
```

## Description

Begin Task placement tool with a given task prototype

## Source

```gdscript
func _start_place_task_tool(task: UnitBaseTask) -> void:
	var tool := TaskPlaceTool.new()
	tool.task = task
	_set_tool(tool)
```
