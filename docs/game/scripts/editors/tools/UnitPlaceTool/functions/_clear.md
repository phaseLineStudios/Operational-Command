# UnitPlaceTool::_clear Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 121–125)</br>
*Belongs to:* [UnitPlaceTool](../../UnitPlaceTool.md)

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
