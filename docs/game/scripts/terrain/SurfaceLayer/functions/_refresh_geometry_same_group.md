# SurfaceLayer::_refresh_geometry_same_group Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 262–290)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _refresh_geometry_same_group(id: int) -> void
```

## Description

Refreshes geometry when points changed but the brush grouping stayed the same

## Source

```gdscript
func _refresh_geometry_same_group(id: int) -> void:
	var key: Variant = _id_to_key.get(id, null)
	var item: Variant = _find_surface_by_id(id)
	if item == null:
		_remove_id(id)
		return
	var brush: TerrainBrush = item.get("brush", null)
	var pts: PackedVector2Array = item.get("points", PackedVector2Array())
	if brush == null or pts.size() < 3:
		_remove_id(id)
		return

	var clamped := renderer.clamp_shape_to_terrain(pts)
	if clamped.size() < 3:
		_remove_id(id)
		return

	var new_key := _brush_key(brush)
	if key == null or key != new_key:
		_upsert_from_data(id, true)
		return

	if _groups.has(key):
		_groups[key].polys[id] = clamped
		_groups[key].bboxes[id] = _poly_bbox(clamped)
		_groups[key].dirty = true
		_start_union_thread(key)
```
