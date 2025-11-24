# ScenarioUnitsCatalog::_cancel_active_tool Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 217–220)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _cancel_active_tool(ctx: ScenarioEditorContext) -> void
```

## Description

Cancel the active tool if one is running

## Source

```gdscript
func _cancel_active_tool(ctx: ScenarioEditorContext) -> void:
	if ctx.current_tool:
		ctx.current_tool.deactivate()
		ctx.current_tool = null
```
