# ScenarioDragLinkService::end_link Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 55–61)</br>
*Belongs to:* [ScenarioDragLinkService](../ScenarioDragLinkService.md)

**Signature**

```gdscript
func end_link(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func end_link(ctx: ScenarioEditorContext) -> void:
	if linking:
		ctx.terrain_overlay.end_link_preview()
	linking = false
	link_src_pick = {}
```
