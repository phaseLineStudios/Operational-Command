# LOSAdapter::_find_simworld Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 94–105)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _find_simworld() -> SimWorld
```

## Source

```gdscript
func _find_simworld() -> SimWorld:
	var node: Node = self
	while node != null:
		if node is SimWorld:
			return node as SimWorld
		for child in node.get_children():
			if child is SimWorld:
				return child as SimWorld
		node = node.get_parent()
	return null
```
