# ScenarioDragLinkService::begin_link Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 43–49)</br>
*Belongs to:* [ScenarioDragLinkService](../ScenarioDragLinkService.md)

**Signature**

```gdscript
func begin_link(ctx: ScenarioEditorContext, src: Dictionary, cursor_pos: Vector2) -> void
```

## Source

```gdscript
func begin_link(ctx: ScenarioEditorContext, src: Dictionary, cursor_pos: Vector2) -> void:
	linking = true
	link_src_pick = src
	ctx.terrain_overlay.begin_link_preview(src)
	ctx.terrain_overlay.update_link_preview(cursor_pos)
```
