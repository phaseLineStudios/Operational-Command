# TerrainPolygonTool::_current_points Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 280–292)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

**Signature**

```gdscript
func _current_points() -> PackedVector2Array
```

## Description

retrieve current polygon points

## Source

```gdscript
func _current_points() -> PackedVector2Array:
	if data == null or _edit_idx < 0:
		return PackedVector2Array()

	var idx := _ensure_current_poly_idx()
	if idx < 0:
		_start_new_polygon()
		idx = _ensure_current_poly_idx()
		if idx < 0:
			return PackedVector2Array()
	return data.surfaces[idx].get("points", PackedVector2Array())
```
