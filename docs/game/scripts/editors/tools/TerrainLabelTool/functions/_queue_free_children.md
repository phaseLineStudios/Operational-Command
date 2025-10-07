# TerrainLabelTool::_queue_free_children Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 233–237)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

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
