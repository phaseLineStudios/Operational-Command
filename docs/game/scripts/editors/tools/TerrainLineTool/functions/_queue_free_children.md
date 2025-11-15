# TerrainLineTool::_queue_free_children Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 399–403)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

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
