# TimerController::_find_mesh_instance Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 464–473)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _find_mesh_instance(node: Node) -> MeshInstance3D
```

## Description

Find MeshInstance3D in children recursively.

## Source

```gdscript
func _find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result := _find_mesh_instance(child)
		if result != null:
			return result
	return null
```
