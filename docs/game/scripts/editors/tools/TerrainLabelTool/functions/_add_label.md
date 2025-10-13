# TerrainLabelTool::_add_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 175–185)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _add_label(local_pos: Vector2, text: String, size: int) -> void
```

## Source

```gdscript
func _add_label(local_pos: Vector2, text: String, size: int) -> void:
	if data == null:
		return
	_ensure_surfaces()
	var label := {
		"id": randi(), "text": text, "pos": local_pos, "rot": label_rotation_deg, "size": size
	}
	data.add_label(label)
	editor.history.push_item_insert(data, "labels", label, "Add label", data.labels.size())
```
