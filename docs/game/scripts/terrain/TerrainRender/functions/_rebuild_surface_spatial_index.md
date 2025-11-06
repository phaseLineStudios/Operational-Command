# TerrainRender::_rebuild_surface_spatial_index Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 260–322)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _rebuild_surface_spatial_index() -> void
```

## Description

Build a spatial hash for polygon AREA surfaces.

## Source

```gdscript
func _rebuild_surface_spatial_index() -> void:
	_surface_index.clear()
	_surface_meta.clear()
	if data == null or data.surfaces == null:
		return

	var surfaces: Array = data.surfaces
	for i in surfaces.size():
		var s: Dictionary = surfaces[i]
		if typeof(s) != TYPE_DICTIONARY:
			continue
		if s.get("type", "") != "polygon":
			continue

		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue

		# Strip closing duplicate if present (prevents per-query copying).
		if pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-10:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue

		# Compute AABB once.
		var bbox := Rect2(pts[0], Vector2.ZERO)
		for p in pts:
			bbox = bbox.expand(p)

		# Store meta and bin into grid cells.
		var meta_idx := _surface_meta.size()
		(
			_surface_meta
			. append(
				{
					"pts": pts,
					"bbox": bbox,
					"z": float(brush.z_index),
					"data_idx": i,
				}
			)
		)

		var cs := float(surface_index_cell_m)
		var min_cx := int(floor(bbox.position.x / cs))
		var min_cy := int(floor(bbox.position.y / cs))
		var max_cx := int(floor((bbox.position.x + bbox.size.x) / cs))
		var max_cy := int(floor((bbox.position.y + bbox.size.y) / cs))

		for cx in range(min_cx, max_cx + 1):
			for cy in range(min_cy, max_cy + 1):
				var key := Vector2i(cx, cy)
				var bucket: PackedInt32Array = _surface_index.get(key, PackedInt32Array())
				bucket.append(meta_idx)
				_surface_index[key] = bucket
```
