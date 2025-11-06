# ScenarioEditorDrawTools::on_draw_click_eraser Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 121–143)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func on_draw_click_eraser() -> void
```

## Description

Start eraser tool.

## Source

```gdscript
func on_draw_click_eraser() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_eraser.button_pressed:
		editor._clear_tool()
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_freehand.set_pressed_no_signal(false)
	editor.draw_toolbar_stamp.set_pressed_no_signal(false)

	# Hide all settings
	editor.fh_settings.visible = false
	editor.st_settings.visible = false
	editor.st_label.visible = false
	editor.st_seperator.visible = false
	editor.st_list.visible = false
	editor.st_load_btn.visible = false

	# Create and activate eraser tool
	var tool := DrawEraserTool.new()
	editor._set_tool(tool)
```
