# TerrainData::add_point Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 268–274)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func add_point(p: Dictionary) -> int
```

## Description

Add a new point. Returns the assigned id.

## Source

```gdscript
func add_point(p: Dictionary) -> int:
	var id := _ensure_id_on_item(p, "_next_point_id")
	points.append(p)
	_queue_emit(_pend_points, "added", PackedInt32Array([id]), "points_changed")
	return id
```
