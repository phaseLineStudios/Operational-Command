# ScenarioEditorDrawTools::on_stamp_selected Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 174–193)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func on_stamp_selected(idx: int) -> void
```

- **idx**: Item index.

## Description

Handle stamp selection change.

## Source

```gdscript
func on_stamp_selected(idx: int) -> void:
	# If tool is already active, just update the texture
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawTextureTool:
		var p := String(editor.st_list.get_item_metadata(idx).get("path", ""))
		editor.ctx.current_tool.texture_path = p
		editor.ctx.current_tool.texture = load(p)
		editor.ctx.request_overlay_redraw()
	# If stamp button is pressed but tool not active, activate it now
	elif editor.draw_toolbar_stamp.button_pressed:
		var tool := DrawTextureTool.new()
		tool.texture_path = String(editor.st_list.get_item_metadata(idx).get("path", ""))
		tool.texture = load(tool.texture_path)
		tool.color = editor.st_color.color
		tool.scale = editor.st_scale.value
		tool.rotation_deg = editor.st_rotation.value
		tool.opacity = editor.st_opacity.value
		tool.label = editor.st_label_text.text
		editor._set_tool(tool)
```
