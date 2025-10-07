# ScenarioDragLinkService::begin_drag Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 12–21)</br>
*Belongs to:* [ScenarioDragLinkService](../../ScenarioDragLinkService.md)

**Signature**

```gdscript
func begin_drag(ctx: ScenarioEditorContext, pick: Dictionary, overlay_pos: Vector2) -> void
```

## Source

```gdscript
func begin_drag(ctx: ScenarioEditorContext, pick: Dictionary, overlay_pos: Vector2) -> void:
	if pick.is_empty():
		return
	dragging = true
	drag_pick = pick
	drag_origin_m = _get_pos(ctx, pick)
	var mp := ctx.terrain_render.map_to_terrain(overlay_pos)
	drag_offset_m = drag_origin_m - mp
```
