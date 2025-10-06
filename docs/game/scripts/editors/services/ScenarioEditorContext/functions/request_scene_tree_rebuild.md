# ScenarioEditorContext::request_scene_tree_rebuild Function Reference

*Defined at:* `scripts/editors/services/ScenarioEditorContext.gd` (lines 39–42)</br>
*Belongs to:* [ScenarioEditorContext](../ScenarioEditorContext.md)

**Signature**

```gdscript
func request_scene_tree_rebuild() -> void
```

## Source

```gdscript
func request_scene_tree_rebuild() -> void:
	scene_tree_rebuild_requested.emit()
```
