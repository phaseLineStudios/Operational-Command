# TerrainData::set_surface_points Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 203–210)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_surface_points(id: int, pts: PackedVector2Array) -> void
```

## Description

Update surface points by id (fast path while drawing).

## Source

```gdscript
func set_surface_points(id: int, pts: PackedVector2Array) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0:
		return
	surfaces[i].points = pts
	_queue_emit(_pend_surfaces, "points", PackedInt32Array([id]), "surfaces_changed")
```
