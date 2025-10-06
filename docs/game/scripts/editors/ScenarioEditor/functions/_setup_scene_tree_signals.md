# ScenarioEditor::_setup_scene_tree_signals Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 195–206)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _setup_scene_tree_signals() -> void
```

## Description

Connect scene tree selection to selection service

## Source

```gdscript
func _setup_scene_tree_signals() -> void:
	scene_tree.item_selected.connect(
		func():
			var it := scene_tree.get_selected()
			if it == null:
				return
			var meta: Variant = it.get_metadata(0)
			if typeof(meta) == TYPE_DICTIONARY and meta.has("type") and meta.has("index"):
				selection.set_selection(ctx, meta, true)
	)
```
