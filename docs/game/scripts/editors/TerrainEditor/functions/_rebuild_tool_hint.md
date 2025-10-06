# TerrainEditor::_rebuild_tool_hint Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 290–295)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _rebuild_tool_hint() -> void
```

## Description

Builds the tool info panel

## Source

```gdscript
func _rebuild_tool_hint() -> void:
	_queue_free_children(tools_hint)
	if active_tool:
		active_tool.build_hint_ui(tools_hint)
```
