# ScenarioDragLinkService::update_drag Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 22–31)</br>
*Belongs to:* [ScenarioDragLinkService](../../ScenarioDragLinkService.md)

**Signature**

```gdscript
func update_drag(ctx: ScenarioEditorContext, overlay_pos: Vector2) -> void
```

## Source

```gdscript
func update_drag(ctx: ScenarioEditorContext, overlay_pos: Vector2) -> void:
	if not dragging:
		return
	var mp := ctx.terrain_render.map_to_terrain(overlay_pos)
	var target := mp + drag_offset_m
	if ctx.terrain_render.is_inside_map(target):
		_set_pos(ctx, drag_pick, target)
		ctx.request_overlay_redraw()
```
