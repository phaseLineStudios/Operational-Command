# DrawEraserTool::_is_near_stroke Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 102–120)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _is_near_stroke(stroke: ScenarioDrawingStroke, _pos_m: Vector2, pos_px: Vector2) -> bool
```

- **stroke**: ScenarioDrawingStroke to check.
- **pos_m**: Click position in terrain space.
- **pos_px**: Click position in screen space.
- **Return Value**: true if near the stroke.

## Description

Check if click is near a stroke.

## Source

```gdscript
func _is_near_stroke(stroke: ScenarioDrawingStroke, _pos_m: Vector2, pos_px: Vector2) -> bool:
	if stroke.points_m.is_empty():
		return false

	var threshold_px: float = max(cursor_radius_px, stroke.width_px * 2.0)
	for i in range(1, stroke.points_m.size()):
		var p1_m := stroke.points_m[i - 1]
		var p2_m := stroke.points_m[i]
		var p1_px := editor.ctx.terrain_render.terrain_to_map(p1_m)
		var p2_px := editor.ctx.terrain_render.terrain_to_map(p2_m)

		# Distance from point to line segment
		var dist := _point_to_segment_distance(pos_px, p1_px, p2_px)
		if dist <= threshold_px:
			return true

	return false
```
