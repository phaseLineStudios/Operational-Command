# FuelSystem::_surface_mult_at Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 261–295)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _surface_mult_at(p_m: Vector2) -> float
```

## Source

```gdscript
func _surface_mult_at(p_m: Vector2) -> float:
	## Returns a surface movement multiplier at the given world position in meters.
	var best: float = 1.0
	var best_z: float = -INF
	var arr: Array = terrain_data.surfaces
	for it in arr:
		if typeof(it) != TYPE_DICTIONARY:
			continue
		var dict: Dictionary = it as Dictionary
		var poly: PackedVector2Array = dict.get("points", PackedVector2Array())
		if poly.is_empty():
			continue

		# Build a quick AABB in meters that covers the polygon.
		var aabb: Rect2 = Rect2(Vector2.INF, Vector2.ZERO)
		for v in poly:
			if aabb.position == Vector2.INF:
				aabb = Rect2(v, Vector2.ZERO)
			else:
				# Godot 4: Rect2.expand(point)
				aabb = aabb.expand(v)

		if not aabb.has_point(p_m):
			continue

		if Geometry2D.is_point_in_polygon(p_m, poly):
			var brush: TerrainBrush = dict.get("brush") as TerrainBrush
			if brush != null:
				var z: float = float(brush.z_index)
				if z >= best_z:
					best_z = z
					best = min(best, brush.movement_multiplier(TerrainBrush.MoveProfile.TRACKED))
	return max(0.25, best)
```
