# TimerController::_is_child_of_timer Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 318–326)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _is_child_of_timer(node: Node) -> bool
```

## Description

Check if a node is part of this timer's hierarchy.

## Source

```gdscript
func _is_child_of_timer(node: Node) -> bool:
	var current := node
	while current != null:
		if current == timer:
			return true
		current = current.get_parent()
	return false
```
