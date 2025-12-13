# AIController::_get_node_from_path Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 442–447)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _get_node_from_path(path: NodePath) -> Node
```

## Source

```gdscript
func _get_node_from_path(path: NodePath) -> Node:
	if path.is_empty():
		return null
	return get_node_or_null(path)
```
