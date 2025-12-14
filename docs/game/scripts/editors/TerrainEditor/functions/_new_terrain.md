# TerrainEditor::_new_terrain Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 126–135)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _new_terrain(d: TerrainData)
```

## Description

Create new terrain data

## Source

```gdscript
func _new_terrain(d: TerrainData):
	data = d
	terrain_render.data = d
	for tool: TerrainToolBase in tool_map.values():
		tool.data = data

	_saved_history_index = _current_history_index
	_dirty = false
```
