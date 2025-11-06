# DrawEraserTool::_point_to_segment_distance Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 149–159)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float
```

- **p**: Point position.
- **a**: Line segment start.
- **b**: Line segment end.
- **Return Value**: Distance in pixels.

## Description

Calculate distance from point to line segment.

## Source

```gdscript
func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var ap := p - a
	var ab_len_sq := ab.length_squared()

	if ab_len_sq == 0.0:
		return ap.length()

	var t := clampf(ap.dot(ab) / ab_len_sq, 0.0, 1.0)
	var projection := a + ab * t
	return p.distance_to(projection)
```
