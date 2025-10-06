# TerrainPointTool::_queue_free_children Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 274–278)</br>
*Belongs to:* [TerrainPointTool](../TerrainPointTool.md)

**Signature**

```gdscript
func _queue_free_children(node: Control)
```

## Source

```gdscript
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
```
