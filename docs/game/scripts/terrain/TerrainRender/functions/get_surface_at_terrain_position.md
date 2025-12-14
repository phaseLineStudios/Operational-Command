# TerrainRender::get_surface_at_terrain_position Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 532–601)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary
```

## Description

Surface under a terrain-local position.
Returns the topmost polygon AREA surface dict or {}.

## Source

```gdscript
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary:
	if data == null or data.surfaces == null:
		return {}

	var base_rect := Rect2(Vector2.ZERO, Vector2(data.width_m, data.height_m))
	if not base_rect.has_point(terrain_pos):
		return {}

	var best_z := -INF
	var best_data_idx := -1

	if not _surface_index.is_empty() and not _surface_meta.is_empty():
		var cs := float(surface_index_cell_m)
		var cell := Vector2i(int(floor(terrain_pos.x / cs)), int(floor(terrain_pos.y / cs)))
		var candidates: PackedInt32Array = _surface_index.get(cell, PackedInt32Array())

		for mi in candidates:
			var m: Dictionary = _surface_meta[mi]
			var bbox: Rect2 = m.bbox
			if not bbox.has_point(terrain_pos):
				continue
			var pts: PackedVector2Array = m.pts
			if Geometry2D.is_point_in_polygon(terrain_pos, pts):
				var z: int = m.z
				var d_idx: int = m.data_idx
				if (z > best_z) or (is_equal_approx(z, best_z) and d_idx > best_data_idx):
					best_z = z
					best_data_idx = d_idx

		if best_data_idx != -1:
			return data.surfaces[best_data_idx]

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

		if pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-10:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue

		var bbox := Rect2(pts[0], Vector2.ZERO)
		for p in pts:
			bbox = bbox.expand(p)
		if not bbox.has_point(terrain_pos):
			continue

		if Geometry2D.is_point_in_polygon(terrain_pos, pts):
			var z := float(brush.z_index)
			if (z > best_z) or (is_equal_approx(z, best_z) and i > best_data_idx):
				best_z = z
				best_data_idx = i

	return {} if best_data_idx == -1 else data.surfaces[best_data_idx]
```
