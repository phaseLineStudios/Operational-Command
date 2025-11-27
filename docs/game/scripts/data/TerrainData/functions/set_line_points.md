# TerrainData::set_line_points Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 238–245)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_line_points(id: int, pts: PackedVector2Array) -> void
```

## Description

Update line points by id (fast path while drawing).

## Source

```gdscript
func set_line_points(id: int, pts: PackedVector2Array) -> void:
	var i := _find_by_id(lines, id)
	if i < 0:
		return
	lines[i].points = pts
	_queue_emit(_pend_lines, "points", PackedInt32Array([id]), "lines_changed")
```
