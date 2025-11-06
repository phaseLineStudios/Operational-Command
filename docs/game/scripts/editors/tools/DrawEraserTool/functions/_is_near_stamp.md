# DrawEraserTool::_is_near_stamp Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 126–143)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _is_near_stamp(stamp: ScenarioDrawingStamp, _pos_m: Vector2, pos_px: Vector2) -> bool
```

- **stamp**: ScenarioDrawingStamp to check.
- **pos_m**: Click position in terrain space.
- **pos_px**: Click position in screen space.
- **Return Value**: true if near the stamp.

## Description

Check if click is near a stamp.

## Source

```gdscript
func _is_near_stamp(stamp: ScenarioDrawingStamp, _pos_m: Vector2, pos_px: Vector2) -> bool:
	# Load texture and calculate size
	var tex: Texture2D = load(stamp.texture_path) if stamp.texture_path != "" else null
	if not tex:
		# Fallback to simple distance check if texture can't be loaded
		var dist_m := _pos_m.distance_to(stamp.position_m)
		return dist_m <= 10.0  # 10 meter default threshold

	# Calculate stamp bounds in pixel space
	var stamp_pos_px := editor.ctx.terrain_render.terrain_to_map(stamp.position_m)
	var stamp_size_px: Vector2 = tex.get_size() * stamp.scale
	var half_size := stamp_size_px * 0.5

	# Check if click is within stamp bounds (simple bounding box check)
	var offset := pos_px - stamp_pos_px
	return abs(offset.x) <= half_size.x and abs(offset.y) <= half_size.y
```
