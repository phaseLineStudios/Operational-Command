# DebugMenuMission::_find_sim_world Function Reference

*Defined at:* `scripts/ui/DebugMenuMission.gd` (lines 142–146)</br>
*Belongs to:* [DebugMenuMission](../../DebugMenuMission.md)

**Signature**

```gdscript
func _find_sim_world(start_node: Node) -> Node
```

## Description

Find SimWorld node in the scene tree

## Source

```gdscript
func _find_sim_world(start_node: Node) -> Node:
	var root := start_node.get_tree().root
	return root.find_child("WorldController", true, false)
```
