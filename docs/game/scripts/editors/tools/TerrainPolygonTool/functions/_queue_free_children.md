# TerrainPolygonTool::_queue_free_children Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 382–386)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

**Signature**

```gdscript
func _queue_free_children(node: Control)
```

## Description

Helper function to delete all children of a parent node

## Source

```gdscript
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
```
