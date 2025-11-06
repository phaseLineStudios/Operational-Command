# DrawingController::_convert_scenario_stroke Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 415–434)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _convert_scenario_stroke(drawing: ScenarioDrawingStroke) -> Dictionary
```

- **drawing**: ScenarioDrawingStroke from scenario.
- **Return Value**: Dictionary with tool and points, or null if conversion fails.

## Description

Convert a ScenarioDrawingStroke to internal stroke format.

## Source

```gdscript
func _convert_scenario_stroke(drawing: ScenarioDrawingStroke) -> Dictionary:
	if drawing.points_m.is_empty():
		return {}

	# Convert 2D terrain points to 3D world points
	var world_points: Array[Vector3] = []
	for point_2d in drawing.points_m:
		var world_point: Variant = _terrain_to_world(point_2d)
		if world_point != null:
			world_points.append(world_point)

	if world_points.is_empty():
		return {}

	# Convert color to tool
	var tool := _color_to_tool(drawing.color)

	return {"tool": tool, "points": world_points, "color": drawing.color}
```
