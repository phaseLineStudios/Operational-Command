# TaskPlaceTool::_clear Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 116–118)</br>
*Belongs to:* [TaskPlaceTool](../../TaskPlaceTool.md)

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
