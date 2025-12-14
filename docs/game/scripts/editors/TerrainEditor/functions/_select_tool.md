# TerrainEditor::_select_tool Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 235–251)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _select_tool(btn: TextureButton) -> void
```

## Description

Select the active tool

## Source

```gdscript
func _select_tool(btn: TextureButton) -> void:
	if active_tool:
		active_tool.destroy_preview()

	for n in tools_grid.get_children():
		if n is TextureButton:
			n.button_pressed = (n == btn)
			_update_tool_button_tint(n)

	active_tool = tool_map[btn]
	_rebuild_options_panel()
	_rebuild_info_panel()
	_rebuild_tool_hint()
	if active_tool:
		active_tool.ensure_preview(brush_overlay)
```
