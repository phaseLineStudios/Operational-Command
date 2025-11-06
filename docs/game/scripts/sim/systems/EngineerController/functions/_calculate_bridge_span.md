# EngineerController::_calculate_bridge_span Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 335–384)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _calculate_bridge_span(water_surface: Dictionary, target_pos: Vector2) -> PackedVector2Array
```

## Description

Calculate optimal bridge span across water

## Source

```gdscript
func _calculate_bridge_span(water_surface: Dictionary, target_pos: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array = water_surface.get("points", PackedVector2Array())
	if points.size() < 2:
		return PackedVector2Array()

	var best_start := Vector2.ZERO
	var best_end := Vector2.ZERO
	var shortest_span := INF

	for i in range(points.size()):
		var p1 := points[i]
		var next_i := (i + 1) % points.size()
		var p2 := points[next_i]

		var edge_center := (p1 + p2) / 2.0
		if target_pos.distance_to(edge_center) > 200.0:
			continue

		for j in range(i + 2, points.size()):
			var p3 := points[j]
			var next_j := (j + 1) % points.size()
			var p4 := points[next_j]

			var span_dist := edge_center.distance_to((p3 + p4) / 2.0)

			if span_dist < shortest_span:
				shortest_span = span_dist
				best_start = edge_center
				best_end = (p3 + p4) / 2.0

	if shortest_span == INF:
		var nearest_point := points[0]
		var nearest_dist := target_pos.distance_to(nearest_point)
		for p in points:
			var dist := target_pos.distance_to(p)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_point = p
		best_start = nearest_point

		var furthest_dist := 0.0
		for p in points:
			var dist := best_start.distance_to(p)
			if dist > furthest_dist:
				furthest_dist = dist
				best_end = p

	return PackedVector2Array([best_start, best_end])
```
