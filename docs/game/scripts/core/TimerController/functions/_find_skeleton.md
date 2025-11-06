# TimerController::_find_skeleton Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 330–339)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _find_skeleton(node: Node) -> Skeleton3D
```

## Description

Find Skeleton3D in children recursively.

## Source

```gdscript
func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result := _find_skeleton(child)
		if result != null:
			return result
	return null
```
