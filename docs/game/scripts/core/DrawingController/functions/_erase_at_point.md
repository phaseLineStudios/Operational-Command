# DrawingController::_erase_at_point Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 153–173)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _erase_at_point(erase_point: Vector3) -> void
```

## Description

Erase strokes at a single point

## Source

```gdscript
func _erase_at_point(erase_point: Vector3) -> void:
	var new_strokes: Array[Dictionary] = []

	for stroke in _strokes:
		var stroke_points: Array = stroke.points
		var tool: Tool = stroke.tool
		var surviving_points: Array[Vector3] = []

		for stroke_point in stroke_points:
			if stroke_point.distance_to(erase_point) >= eraser_width:
				surviving_points.append(stroke_point)

		if surviving_points.size() > 0:
			var segments := _split_into_segments(surviving_points, stroke_points)
			for segment in segments:
				if segment.size() >= 2:
					new_strokes.append({"tool": tool, "points": segment})

	_strokes = new_strokes
```
