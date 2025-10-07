# ScenarioDragLinkService::end_drag Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 32–42)</br>
*Belongs to:* [ScenarioDragLinkService](../../ScenarioDragLinkService.md)

**Signature**

```gdscript
func end_drag(ctx: ScenarioEditorContext, commit := true) -> void
```

## Source

```gdscript
func end_drag(ctx: ScenarioEditorContext, commit := true) -> void:
	if not dragging:
		return
	if not commit:
		_set_pos(ctx, drag_pick, drag_origin_m)
	else:
		_commit_move(ctx, drag_pick, drag_origin_m, _get_pos(ctx, drag_pick))
	dragging = false
	drag_pick = {}
```
