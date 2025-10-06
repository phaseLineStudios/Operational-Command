# ScenarioSelectionService::_select_in_tree Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 37–46)</br>
*Belongs to:* [ScenarioSelectionService](../ScenarioSelectionService.md)

**Signature**

```gdscript
func _select_in_tree(ctx: ScenarioEditorContext, pick: Dictionary) -> void
```

## Source

```gdscript
func _select_in_tree(ctx: ScenarioEditorContext, pick: Dictionary) -> void:
	if pick.is_empty():
		ctx.scene_tree.deselect_all()
		return
	var root := ctx.scene_tree.get_root()
	if root == null:
		return
	_select_recursive(ctx.scene_tree, root, pick)
```
