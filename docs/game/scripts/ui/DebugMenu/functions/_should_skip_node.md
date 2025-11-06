# DebugMenu::_should_skip_node Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 259–283)</br>
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
	# Skip the debug menu itself
	if node == self or node == get_parent():
		return true

	# Skip Window nodes (like root window)
	if node is Window:
		return true

	# Skip Collision nodes
	if node is CollisionShape3D:
		return true

	# Skip common autoloads/singletons that shouldn't have debug options
	var node_name := node.name
	if node_name in ["Game", "ContentDB", "LogService", "Persistence", "STTService", "NARules"]:
		return true

	# Skip viewport internals
	if node_name.begins_with("@"):
		return true

	return false
```
