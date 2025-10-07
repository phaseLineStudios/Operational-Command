# TerrainEditor::_queue_free_children Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 463–467)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

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
