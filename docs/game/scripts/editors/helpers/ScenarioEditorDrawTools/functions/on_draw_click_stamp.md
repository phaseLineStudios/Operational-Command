# ScenarioEditorDrawTools::on_draw_click_stamp Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 82–119)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func on_draw_click_stamp() -> void
```

## Description

Start stamp tool with current UI + selected texture.

## Source

```gdscript
func on_draw_click_stamp() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_stamp.button_pressed:
		editor._clear_tool()
		editor.st_settings.visible = false
		editor.st_label.visible = false
		editor.st_seperator.visible = false
		editor.st_list.visible = false
		editor.st_load_btn.visible = false
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_freehand.set_pressed_no_signal(false)
	editor.draw_toolbar_eraser.set_pressed_no_signal(false)

	# Show stamp settings, hide others
	editor.fh_settings.visible = false
	editor.st_settings.visible = true
	editor.st_seperator.visible = true
	editor.st_label.visible = true
	editor.st_load_btn.visible = true
	editor.st_list.visible = true

	# Try to activate tool if texture is selected, otherwise just show UI
	var sel := editor.st_list.get_selected_items()
	if not sel.is_empty():
		var idx := sel[0]
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
