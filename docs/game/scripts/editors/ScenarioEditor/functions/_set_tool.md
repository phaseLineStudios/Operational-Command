# ScenarioEditor::_set_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 335–349)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _set_tool(tool: ScenarioToolBase) -> void
```

## Description

Set or clear current tool and wire its signals

## Source

```gdscript
func _set_tool(tool: ScenarioToolBase) -> void:
	if ctx.current_tool:
		ctx.current_tool.deactivate()
	ctx.current_tool = tool
	if tool:
		tool.activate(self)
		tool.build_hint_ui(tool_hint)
		tool.request_redraw_overlay.connect(func(): ctx.request_overlay_redraw())
		tool.finished.connect(func(): _clear_tool())
		tool.canceled.connect(func(): _clear_tool())
		ctx.request_overlay_redraw()
	else:
		_clear_hint()
```
