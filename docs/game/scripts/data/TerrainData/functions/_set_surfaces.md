# TerrainData::_set_surfaces Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 182–187)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_surfaces(v) -> void
```

## Source

```gdscript
func _set_surfaces(v) -> void:
	surfaces = _ensure_ids(v, "_next_surface_id")
	_queue_emit(_pend_surfaces, "reset", _collect_ids(surfaces), "surfaces_changed")
	emit_signal("changed")
```
