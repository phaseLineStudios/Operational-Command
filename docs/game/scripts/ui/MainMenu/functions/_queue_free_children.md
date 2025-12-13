# MainMenu::_queue_free_children Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 194–198)</br>
*Belongs to:* [MainMenu](../../MainMenu.md)

**Signature**

```gdscript
func _queue_free_children(node: Node) -> void
```

## Source

```gdscript
static func _queue_free_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
```
