# DebugMenu::_should_skip_node Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 252–271)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _should_skip_node(node: Node) -> bool
```

## Description

Check if we should skip scanning this node

## Source

```gdscript
func _should_skip_node(node: Node) -> bool:
	if node == self or node == get_parent():
		return true

	if node is Window:
		return true

	if node is CollisionShape3D:
		return true

	var node_name := node.name
	if node_name in ["Game", "ContentDB", "LogService", "Persistence", "STTService", "NARules"]:
		return true

	if node_name.begins_with("@"):
		return true

	return false
```
