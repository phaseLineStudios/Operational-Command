# TerrainEditor::_edit_terrain Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 135–143)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _edit_terrain(_d: TerrainData)
```

## Description

Create new terrain data

## Source

```gdscript
func _edit_terrain(_d: TerrainData):
	terrain_render.data = data

	for tool: TerrainToolBase in tool_map.values():
		tool.data = data

	_dirty = true
```
