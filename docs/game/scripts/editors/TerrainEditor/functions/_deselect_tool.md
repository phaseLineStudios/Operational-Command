# TerrainEditor::_deselect_tool Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 253–267)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _deselect_tool(_btn: TextureButton) -> void
```

## Description

Deselect the active tool

## Source

```gdscript
func _deselect_tool(_btn: TextureButton) -> void:
	if active_tool:
		active_tool.destroy_preview()
		active_tool = null

	for n in tools_grid.get_children():
		if n is TextureButton:
			n.button_pressed = false
			_update_tool_button_tint(n)

	_rebuild_options_panel()
	_rebuild_info_panel()
	_rebuild_tool_hint()
```
