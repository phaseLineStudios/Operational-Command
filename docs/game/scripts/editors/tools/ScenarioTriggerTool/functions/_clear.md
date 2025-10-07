# ScenarioTriggerTool::_clear Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 107–109)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

**Signature**

```gdscript
func _clear(node: Control) -> void
```

## Source

```gdscript
func _clear(node: Control) -> void:
	for c in node.get_children():
		c.queue_free()
```
