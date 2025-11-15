# TerrainPointTool::_rebuild_info_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 98–108)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _rebuild_info_ui() -> void
```

## Source

```gdscript
func _rebuild_info_ui() -> void:
	if not _info_ui_parent or not active_brush:
		return
	_queue_free_children(_info_ui_parent)
	var l := RichTextLabel.new()
	l.bbcode_enabled = true
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.text = "Place point features"
	_info_ui_parent.add_child(l)
```
