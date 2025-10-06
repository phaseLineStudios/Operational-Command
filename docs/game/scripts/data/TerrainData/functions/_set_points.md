# TerrainData::_set_points Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 176–181)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func _set_points(v) -> void
```

## Source

```gdscript
func _set_points(v) -> void:
	points = _ensure_ids(v, "_next_point_id")
	_queue_emit(_pend_points, "reset", _collect_ids(points), "points_changed")
	emit_signal("changed")
```
