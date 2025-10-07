# SurfaceLayer::_upsert_from_data Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 213–246)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _upsert_from_data(id: int, rebuild_old_key: bool) -> void
```

## Description

Inserts/updates one surface from data, moving between groups if needed

## Source

```gdscript
func _upsert_from_data(id: int, rebuild_old_key: bool) -> void:
	var item: Variant = _find_surface_by_id(id)
	if item == null:
		return
	if item.get("type", "") != "polygon":
		return
	var brush: TerrainBrush = item.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
		return
	var pts: PackedVector2Array = item.get("points", PackedVector2Array())
	if pts.size() < 3:
		return

	var clamped := renderer.clamp_shape_to_terrain(pts)
	if clamped.size() < 3:
		return

	var new_key := _brush_key(brush)
	_ensure_group(new_key, brush)

	var old_key: Variant = _id_to_key.get(id, null)
	if rebuild_old_key and old_key != null and old_key != new_key and _groups.has(old_key):
		_groups[old_key].polys.erase(id)
		_groups[old_key].bboxes.erase(id)
		_groups[old_key].dirty = true
		_start_union_thread(old_key)

	_groups[new_key].polys[id] = clamped
	_groups[new_key].bboxes[id] = _poly_bbox(clamped)
	_groups[new_key].dirty = true
	_id_to_key[id] = new_key
	_start_union_thread(new_key)
```
