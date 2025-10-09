# TerrainRender::get_surface_at_terrain_position Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 390–433)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary
```

## Description

API to get surface at map position

## Source

```gdscript
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary:
	if data == null or data.surfaces == null:
		return {}

	var base_rect := Rect2(Vector2.ZERO, Vector2(data.width_m, data.height_m))
	if not base_rect.has_point(terrain_pos):
		return {}

	var best := {}
	var best_z := -INF
	var best_idx := -1

	for i in data.surfaces.size():
		var s = data.surfaces[i]
		if typeof(s) != TYPE_DICTIONARY:
			continue
		if s.get("type", "") != "polygon":
			continue

		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue
		var z := brush.z_index

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue

		if pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-10:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue

		if Geometry2D.is_point_in_polygon(terrain_pos, pts):
			if (z > best_z) or (z == best_z and i > best_idx):
				best = s
				best_z = z
				best_idx = i

	return best
```
