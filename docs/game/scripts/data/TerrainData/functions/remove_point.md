# TerrainData::remove_point Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 287–294)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func remove_point(id: int) -> void
```

## Description

Remove point by id

## Source

```gdscript
func remove_point(id: int) -> void:
	var i := _find_by_id(points, id)
	if i < 0:
		return
	points.remove_at(i)
	_queue_emit(_pend_points, "removed", PackedInt32Array([id]), "points_changed")
```
