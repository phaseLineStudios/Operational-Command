# ScenarioEditor::_queue_free_children Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 611–615)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _queue_free_children(node: Control)
```

## Description

Utility: queue_free all children of a UI container

## Source

```gdscript
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
```
