# ScenarioEditorDrawTools::sync_freehand_opts Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 145–155)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func sync_freehand_opts() -> void
```

## Description

Update active freehand tool when UI changes.

## Source

```gdscript
func sync_freehand_opts() -> void:
	freehand_defaults.color = editor.fh_color.color
	freehand_defaults.width_px = editor.fh_width.value
	freehand_defaults.opacity = editor.fh_opacity.value
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawFreehandTool:
		editor.ctx.current_tool.color = editor.fh_color.color
		editor.ctx.current_tool.width_px = editor.fh_width.value
		editor.ctx.current_tool.opacity = editor.fh_opacity.value
		editor.ctx.request_overlay_redraw()
```
