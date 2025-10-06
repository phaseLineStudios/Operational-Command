# TerrainEditor::_rebuild_info_panel Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 283–288)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _rebuild_info_panel() -> void
```

## Description

Builds the tool info panel

## Source

```gdscript
func _rebuild_info_panel() -> void:
	_queue_free_children(tools_info)
	if active_tool:
		active_tool.build_info_ui(tools_info)
```
