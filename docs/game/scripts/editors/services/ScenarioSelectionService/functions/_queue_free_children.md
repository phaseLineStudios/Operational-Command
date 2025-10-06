# ScenarioSelectionService::_queue_free_children Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 64–66)</br>
*Belongs to:* [ScenarioSelectionService](../ScenarioSelectionService.md)

**Signature**

```gdscript
func _queue_free_children(node: Control) -> void
```

## Source

```gdscript
func _queue_free_children(node: Control) -> void:
	for n in node.get_children():
		n.queue_free()
```
