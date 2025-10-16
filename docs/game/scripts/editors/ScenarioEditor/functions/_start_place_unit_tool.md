# ScenarioEditor::_start_place_unit_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 270–275)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _start_place_unit_tool(payload: Variant) -> void
```

## Description

Begin Unit/Slot placement tool with a given payload

## Source

```gdscript
func _start_place_unit_tool(payload: Variant) -> void:
	var tool := UnitPlaceTool.new()
	tool.payload = payload
	_set_tool(tool)
```
