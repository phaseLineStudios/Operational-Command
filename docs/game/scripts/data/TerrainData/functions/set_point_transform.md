# TerrainData::set_point_transform Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 282–291)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_point_transform(id: int, pos: Vector2, rot: float, scale: float = 1.0) -> void
```

## Description

Update points transformation

## Source

```gdscript
func set_point_transform(id: int, pos: Vector2, rot: float, scale: float = 1.0) -> void:
	var i := _find_by_id(points, id)
	if i < 0:
		return
	points[i].pos = pos
	points[i].rot = rot
	points[i].scale = scale
	_queue_emit(_pend_points, "move", PackedInt32Array([id]), "points_changed")
```
