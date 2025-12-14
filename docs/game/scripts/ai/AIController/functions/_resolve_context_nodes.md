# AIController::_resolve_context_nodes Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 411–417)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _resolve_context_nodes() -> void
```

## Source

```gdscript
func _resolve_context_nodes() -> void:
	_sim = sim_world_ref if sim_world_ref else _get_node_from_path(sim_world_path) as SimWorld
	if _sim == null:
		_sim = get_tree().get_root().find_child("SimWorld", true, false)
	_ensure_adapter_cache()
```
