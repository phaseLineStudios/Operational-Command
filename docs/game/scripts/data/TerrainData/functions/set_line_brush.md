# TerrainData::set_line_brush Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 256–263)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_line_brush(id: int, brush: TerrainBrush) -> void
```

## Description

Update line brush by id.

## Source

```gdscript
func set_line_brush(id: int, brush: TerrainBrush) -> void:
	var i := _find_by_id(lines, id)
	if i < 0:
		return
	lines[i].brush = brush
	_queue_emit(_pend_lines, "brush", PackedInt32Array([id]), "lines_changed")
```
