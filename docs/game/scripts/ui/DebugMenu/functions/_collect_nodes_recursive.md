# DebugMenu::_collect_nodes_recursive Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 501–510)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _collect_nodes_recursive(node: Node, out: Array[Node]) -> void
```

## Description

Recursively collect all nodes in the tree

## Source

```gdscript
func _collect_nodes_recursive(node: Node, out: Array[Node]) -> void:
	if node == null:
		return

	out.append(node)

	for child in node.get_children():
		_collect_nodes_recursive(child, out)
```
