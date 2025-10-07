# AmmoRearmPanel::_clear_children Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 274–276)</br>
*Belongs to:* [AmmoRearmPanel](../../AmmoRearmPanel.md)

**Signature**

```gdscript
func _clear_children(n: Node) -> void
```

## Source

```gdscript
func _clear_children(n: Node) -> void:
	for c in n.get_children():
		(c as Node).queue_free()
```
