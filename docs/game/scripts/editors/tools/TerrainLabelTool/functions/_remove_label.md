# TerrainLabelTool::_remove_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 193–204)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _remove_label(idx: int) -> void
```

## Source

```gdscript
func _remove_label(idx: int) -> void:
	if data == null or idx < 0 or idx >= data.labels.size():
		return
	var d: Dictionary = data.labels[idx]
	var id = d.get("id", null)
	if id == null:
		return
	var copy := d.duplicate(true)
	editor.history.push_item_erase_by_id(data, "labels", id, copy, "Delete label", idx)
	data.remove_label(id)
```
