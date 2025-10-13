# ScenarioDragLinkService::update_link Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 50–54)</br>
*Belongs to:* [ScenarioDragLinkService](../../ScenarioDragLinkService.md)

**Signature**

```gdscript
func update_link(ctx: ScenarioEditorContext, cursor_pos: Vector2) -> void
```

## Source

```gdscript
func update_link(ctx: ScenarioEditorContext, cursor_pos: Vector2) -> void:
	if linking:
		ctx.terrain_overlay.update_link_preview(cursor_pos)
```
