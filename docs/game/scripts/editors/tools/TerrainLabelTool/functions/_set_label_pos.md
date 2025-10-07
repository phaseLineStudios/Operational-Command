# TerrainLabelTool::_set_label_pos Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 186–192)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _set_label_pos(idx: int, local_pos: Vector2) -> void
```

## Source

```gdscript
func _set_label_pos(idx: int, local_pos: Vector2) -> void:
	if data == null or idx < 0 or idx >= data.labels.size():
		return
	var d: Dictionary = data.labels[idx]
	data.set_label_pose(d.id, local_pos, label_rotation_deg)
```
