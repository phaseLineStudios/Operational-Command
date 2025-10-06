# ScenarioSelectionService::_select_recursive Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 47–63)</br>
*Belongs to:* [ScenarioSelectionService](../ScenarioSelectionService.md)

**Signature**

```gdscript
func _select_recursive(tree: Tree, item: TreeItem, pick: Dictionary) -> bool
```

## Source

```gdscript
func _select_recursive(tree: Tree, item: TreeItem, pick: Dictionary) -> bool:
	var meta: Variant = item.get_metadata(0)
	if (
		typeof(meta) == TYPE_DICTIONARY
		and meta.get("type", "") == pick.get("type", "")
		and int(meta.get("index", -1)) == int(pick.get("index", -1))
	):
		tree.set_selected(item, 0)
		return true
	var child := item.get_first_child()
	while child:
		if _select_recursive(tree, child, pick):
			return true
		child = child.get_next()
	return false
```
