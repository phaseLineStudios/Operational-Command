# TerrainPolygonTool::_find_edit_index_by_id Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 294–303)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _find_edit_index_by_id() -> int
```

## Description

Helper function to find current polygon in Terrain Data

## Source

```gdscript
func _find_edit_index_by_id() -> int:
	if data == null or _edit_id < 0:
		return -1
	for i in data.surfaces.size():
		var s = data.surfaces[i]
		if "id" in s and int(s.id) == _edit_id:
			return i
	return -1
```
