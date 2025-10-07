# MissionSelect::_clear_children Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 305–308)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _clear_children(node: Node) -> void
```

## Description

Remove all children from a node.

## Source

```gdscript
func _clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
```
