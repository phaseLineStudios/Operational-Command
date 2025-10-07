# TerrainPolygonTool::_ensure_current_poly_idx Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 394–404)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _ensure_current_poly_idx() -> int
```

## Description

Ensure _edit_idx points at the polygon with _edit_id, return index or -1

## Source

```gdscript
func _ensure_current_poly_idx() -> int:
	if data == null or _edit_id < 0:
		return -1
	if _edit_idx >= 0 and _edit_idx < data.surfaces.size():
		var s: Dictionary = data.surfaces[_edit_idx]
		if typeof(s) == TYPE_DICTIONARY and s.get("id", null) == _edit_id:
			return _edit_idx
	_edit_idx = _find_edit_index_by_id()
	return _edit_idx
```
