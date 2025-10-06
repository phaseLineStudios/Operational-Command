# ScenarioEditor::_start_place_trigger_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 273–278)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _start_place_trigger_tool(proto: ScenarioTrigger) -> void
```

## Description

Begin Trigger placement tool with a trigger prototype

## Source

```gdscript
func _start_place_trigger_tool(proto: ScenarioTrigger) -> void:
	var tool := ScenarioTriggerTool.new()
	tool.prototype = proto
	_set_tool(tool)
```
