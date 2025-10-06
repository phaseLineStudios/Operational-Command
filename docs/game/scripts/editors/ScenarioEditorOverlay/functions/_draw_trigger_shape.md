# ScenarioEditorOverlay::_draw_trigger_shape Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 312–343)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_trigger_shape(trig: ScenarioTrigger, center_px: Vector2, hi: bool) -> void
```

## Description

Draw a single trigger's shape + icon with hover colors

## Source

```gdscript
func _draw_trigger_shape(trig: ScenarioTrigger, center_px: Vector2, hi: bool) -> void:
	var fill := trigger_fill
	var line := trigger_outline
	var tex := _get_scaled_icon_trigger(trig)
	if hi:
		fill = Color(fill, min(1.0, fill.a + 0.15))
		line = line.lightened(0.15)

	if trig.area_shape == ScenarioTrigger.AreaShape.CIRCLE:
		var r_m: float = max(trig.area_size_m.x, trig.area_size_m.y) * 0.5
		var edge_px := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(r_m, 0.0))
		var r_px := edge_px.distance_to(center_px)
		draw_circle(center_px, r_px, fill)
		draw_arc(center_px, r_px, 0.0, TAU, 64, line, 2.0, true)
	else:
		var hx_m := trig.area_size_m.x * 0.5
		var hy_m := trig.area_size_m.y * 0.5
		var p_x := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(hx_m, 0.0))
		var p_y := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(0.0, hy_m))
		var half_w_px: float = abs(p_x.x - center_px.x)
		var half_h_px: float = abs(p_y.y - center_px.y)
		var rect := Rect2(
			Vector2(center_px.x - half_w_px, center_px.y - half_h_px),
			Vector2(half_w_px * 2.0, half_h_px * 2.0)
		)
		draw_rect(rect, fill, true)
		draw_rect(rect, line, false, 2.0)
	if tex:
		var p := editor.terrain_render.terrain_to_map(trig.area_center_m)
		_draw_icon_with_hover(tex, p, hi)
```
