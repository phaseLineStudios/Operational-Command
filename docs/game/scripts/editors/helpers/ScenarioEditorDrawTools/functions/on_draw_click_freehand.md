# ScenarioEditorDrawTools::on_draw_click_freehand Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 54–80)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func on_draw_click_freehand() -> void
```

## Description

Start freehand tool with current UI values.

## Source

```gdscript
func on_draw_click_freehand() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_freehand.button_pressed:
		editor._clear_tool()
		editor.fh_settings.visible = false
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_stamp.set_pressed_no_signal(false)
	editor.draw_toolbar_eraser.set_pressed_no_signal(false)

	# Show freehand settings, hide others
	editor.fh_settings.visible = true
	editor.st_settings.visible = false
	editor.st_label.visible = false
	editor.st_seperator.visible = false
	editor.st_list.visible = false
	editor.st_load_btn.visible = false

	# Create and activate freehand tool
	var tool := DrawFreehandTool.new()
	tool.color = editor.fh_color.color
	tool.width_px = editor.fh_width.value
	tool.opacity = editor.fh_opacity.value
	editor._set_tool(tool)
```
