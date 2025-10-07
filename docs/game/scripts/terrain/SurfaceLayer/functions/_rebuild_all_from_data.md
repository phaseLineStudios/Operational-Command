# SurfaceLayer::_rebuild_all_from_data Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 153–198)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _rebuild_all_from_data() -> void
```

## Description

Full rebuild from TerrainData

## Source

```gdscript
func _rebuild_all_from_data() -> void:
	_cancel_all_threads()
	_groups.clear()
	_id_to_key.clear()
	_dirty_all = false

	if data == null or data.surfaces.is_empty():
		emit_signal("batches_rebuilt")
		return

	for s in data.surfaces:
		if s == null or typeof(s) != TYPE_DICTIONARY:
			continue
		if s.get("type", "") != "polygon":
			continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue
		var id := int(s.get("id", 0))
		if id <= 0:
			continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue

		var clamped := renderer.clamp_shape_to_terrain(pts)
		if clamped.size() < 3:
			continue

		var key := _brush_key(brush)
		_ensure_group(key, brush)

		_groups[key].polys[id] = clamped
		_groups[key].bboxes[id] = _poly_bbox(clamped)
		_id_to_key[id] = key

	for key in _groups.keys():
		var group = _groups[key]
		group.merged = group.polys.values()
		group.dirty = true
		_start_union_thread(key)

	emit_signal("batches_rebuilt")
```
