# ScenarioSelectionService::clear_selection Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 15–23)</br>
*Belongs to:* [ScenarioSelectionService](../../ScenarioSelectionService.md)

**Signature**

```gdscript
func clear_selection(ctx: ScenarioEditorContext, from_tree := false) -> void
```

## Source

```gdscript
func clear_selection(ctx: ScenarioEditorContext, from_tree := false) -> void:
	ctx.selected_pick = {}
	ctx.terrain_overlay.clear_selected()
	_queue_free_children(ctx.tool_hint)
	ctx.request_overlay_redraw()
	if not from_tree:
		ctx.scene_tree.deselect_all()
```
