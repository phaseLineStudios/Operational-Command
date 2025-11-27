# ScenarioEditor::_rebuild_scene_tree Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 185–190)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _rebuild_scene_tree() -> void
```

## Description

Rebuild the left scene tree and restore selection

## Source

```gdscript
func _rebuild_scene_tree() -> void:
	tree_service.rebuild(ctx)
	if not ctx.selected_pick.is_empty():
		selection.set_selection(ctx, ctx.selected_pick, true)
```
