# ScenarioSelectionService::set_selection Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 5–14)</br>
*Belongs to:* [ScenarioSelectionService](../ScenarioSelectionService.md)

**Signature**

```gdscript
func set_selection(ctx: ScenarioEditorContext, pick: Dictionary, from_tree := false) -> void
```

## Source

```gdscript
func set_selection(ctx: ScenarioEditorContext, pick: Dictionary, from_tree := false) -> void:
	ctx.selected_pick = pick if pick != null else {}
	ctx.terrain_overlay.set_selected(ctx.selected_pick)
	_build_hint(ctx, pick)
	ctx.request_overlay_redraw()
	if not from_tree:
		_select_in_tree(ctx, pick)
	ctx.selection_changed.emit(pick)
```
