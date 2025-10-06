# ScenarioSelectionService Class Reference

*File:* `scripts/editors/services/ScenarioSelectionService.gd`
*Class name:* `ScenarioSelectionService`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioSelectionService
extends RefCounted
```

## Public Member Functions

- [`func set_selection(ctx: ScenarioEditorContext, pick: Dictionary, from_tree := false) -> void`](ScenarioSelectionService/functions/set_selection.md)
- [`func clear_selection(ctx: ScenarioEditorContext, from_tree := false) -> void`](ScenarioSelectionService/functions/clear_selection.md)
- [`func _build_hint(ctx: ScenarioEditorContext, pick: Dictionary) -> void`](ScenarioSelectionService/functions/_build_hint.md)
- [`func _select_in_tree(ctx: ScenarioEditorContext, pick: Dictionary) -> void`](ScenarioSelectionService/functions/_select_in_tree.md)
- [`func _select_recursive(tree: Tree, item: TreeItem, pick: Dictionary) -> bool`](ScenarioSelectionService/functions/_select_recursive.md)
- [`func _queue_free_children(node: Control) -> void`](ScenarioSelectionService/functions/_queue_free_children.md)

## Member Function Documentation

### set_selection

```gdscript
func set_selection(ctx: ScenarioEditorContext, pick: Dictionary, from_tree := false) -> void
```

### clear_selection

```gdscript
func clear_selection(ctx: ScenarioEditorContext, from_tree := false) -> void
```

### _build_hint

```gdscript
func _build_hint(ctx: ScenarioEditorContext, pick: Dictionary) -> void
```

### _select_in_tree

```gdscript
func _select_in_tree(ctx: ScenarioEditorContext, pick: Dictionary) -> void
```

### _select_recursive

```gdscript
func _select_recursive(tree: Tree, item: TreeItem, pick: Dictionary) -> bool
```

### _queue_free_children

```gdscript
func _queue_free_children(node: Control) -> void
```
