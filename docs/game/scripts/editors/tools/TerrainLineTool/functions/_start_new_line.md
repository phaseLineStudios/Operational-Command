# TerrainLineTool::_start_new_line Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 303–322)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _start_new_line() -> void
```

## Source

```gdscript
func _start_new_line() -> void:
	if data == null:
		return
	if active_brush == null or active_brush.feature_type != TerrainBrush.FeatureType.LINEAR:
		return
	var pid := _next_id
	_next_id += 1
	var line := {
		"id": pid,
		"brush": active_brush,
		"points": PackedVector2Array(),
		"closed": false,
		"width_px": line_width_px
	}
	data.add_line(line)
	editor.history.push_item_insert(data, "lines", line, "Add line", data.lines.size())
	_edit_id = pid
	_edit_idx = data.lines.size() - 1
```
