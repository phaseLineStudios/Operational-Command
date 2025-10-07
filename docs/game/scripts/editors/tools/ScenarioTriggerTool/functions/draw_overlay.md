# ScenarioTriggerTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 72–100)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

**Signature**

```gdscript
func draw_overlay(canvas: Control) -> void
```

## Source

```gdscript
func draw_overlay(canvas: Control) -> void:
	if not _hover_valid or not prototype:
		return
	var center_px := editor.terrain_render.terrain_to_map(_hover_map_pos)
	var col := Color(Color.LIGHT_SKY_BLUE, 0.25)
	var outline := Color(Color.DEEP_SKY_BLUE, 0.9)
	var size_m := prototype.area_size_m

	if prototype.area_shape == ScenarioTrigger.AreaShape.CIRCLE:
		var r_m: float = max(size_m.x, size_m.y) * 0.5
		var edge_px := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(r_m, 0.0))
		var r_px := edge_px.distance_to(center_px)
		canvas.draw_circle(center_px, r_px, col)
		canvas.draw_arc(center_px, r_px, 0.0, TAU, 64, outline, 2.0, true)
	else:
		var hx_m := size_m.x * 0.5
		var hy_m := size_m.y * 0.5
		var p_x := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(hx_m, 0.0))
		var p_y := editor.terrain_render.terrain_to_map(_hover_map_pos + Vector2(0.0, hy_m))
		var half_w_px: float = abs(p_x.x - center_px.x)
		var half_h_px: float = abs(p_y.y - center_px.y)
		var rect := Rect2(
			Vector2(center_px.x - half_w_px, center_px.y - half_h_px),
			Vector2(half_w_px * 2.0, half_h_px * 2.0)
		)
		canvas.draw_rect(rect, col, true)
		canvas.draw_rect(rect, outline, false, 2.0)
```
