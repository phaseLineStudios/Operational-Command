# ScenarioEditorDrawTools::sync_stamp_opts Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 157–171)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func sync_stamp_opts() -> void
```

## Description

Update active stamp tool when UI changes.

## Source

```gdscript
func sync_stamp_opts() -> void:
	stamp_defaults.color = editor.st_color.color
	stamp_defaults.scale = editor.st_scale.value
	stamp_defaults.rotation_deg = editor.st_rotation.value
	stamp_defaults.opacity = editor.st_opacity.value
	stamp_defaults.label = editor.st_label_text.text
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawTextureTool:
		editor.ctx.current_tool.color = editor.st_color.color
		editor.ctx.current_tool.scale = editor.st_scale.value
		editor.ctx.current_tool.rotation_deg = editor.st_rotation.value
		editor.ctx.current_tool.opacity = editor.st_opacity.value
		editor.ctx.current_tool.label = editor.st_label_text.text
		editor.ctx.request_overlay_redraw()
```
