# MainMenu::_clear_children Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 193–195)</br>
*Belongs to:* [MainMenu](../../MainMenu.md)

**Signature**

```gdscript
func _clear_children(node: Node) -> void
```

## Source

```gdscript
static func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
```
