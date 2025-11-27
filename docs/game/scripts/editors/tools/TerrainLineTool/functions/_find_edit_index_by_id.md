# TerrainLineTool::_find_edit_index_by_id Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 333–342)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _find_edit_index_by_id() -> int
```

## Source

```gdscript
func _find_edit_index_by_id() -> int:
	if data == null or _edit_id < 0:
		return -1
	for i in data.lines.size():
		var s = data.lines[i]
		if "id" in s and int(s.id) == _edit_id:
			return i
	return -1
```
