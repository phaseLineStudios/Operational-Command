# TerrainEditor::_rebuild_options_panel Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 276–281)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _rebuild_options_panel() -> void
```

## Description

Rebuild the options panel for the selected tool

## Source

```gdscript
func _rebuild_options_panel() -> void:
	_queue_free_children(tools_options)
	if active_tool:
		active_tool.build_options_ui(tools_options)
```
