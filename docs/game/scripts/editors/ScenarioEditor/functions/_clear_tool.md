# ScenarioEditor::_clear_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 355–359)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _clear_tool() -> void
```

## Description

Clear current tool

## Source

```gdscript
func _clear_tool() -> void:
	LogService.trace("clear tool", "ScenarioEditor.gd:280")
	_set_tool(null)
```
