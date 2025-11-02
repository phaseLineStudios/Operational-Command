# ReinforcementPanel::_clear_children Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 289–293)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _clear_children(n: Node) -> void
```

## Description

Clear all children from a container.

## Source

```gdscript
func _clear_children(n: Node) -> void:
	for c in n.get_children():
		c.queue_free()
```
