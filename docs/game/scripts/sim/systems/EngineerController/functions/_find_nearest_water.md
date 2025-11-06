# EngineerController::_find_nearest_water Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 258–302)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _find_nearest_water(pos: Vector2) -> Variant
```

## Description

Find the nearest water feature to a position (checks both surfaces and lines)

## Source

```gdscript
func _find_nearest_water(pos: Vector2) -> Variant:
	if not terrain_renderer or not terrain_renderer.data:
		return null

	var terrain := terrain_renderer.data
	var nearest_feature: Variant = null
	var nearest_dist := INF

	for surface in terrain.surfaces:
		if not surface is Dictionary:
			continue

		if not _is_water_feature(surface):
			continue

		var points: PackedVector2Array = surface.get("points", PackedVector2Array())
		if points.size() == 0:
			continue

		var center := _calculate_center(points)
		var dist := pos.distance_to(center)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_feature = surface

	for line in terrain.lines:
		if not line is Dictionary:
			continue

		if not _is_water_feature(line):
			continue

		var points: PackedVector2Array = line.get("points", PackedVector2Array())
		if points.size() == 0:
			continue

		var center := _calculate_center(points)
		var dist := pos.distance_to(center)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_feature = line

	return nearest_feature
```
