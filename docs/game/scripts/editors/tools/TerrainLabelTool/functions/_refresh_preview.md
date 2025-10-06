# TerrainLabelTool::_refresh_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 37–50)</br>
*Belongs to:* [TerrainLabelTool](../TerrainLabelTool.md)

**Signature**

```gdscript
func _refresh_preview() -> void
```

## Source

```gdscript
func _refresh_preview() -> void:
	if _preview == null:
		return
	if _preview is LabelPreview:
		var p := _preview as LabelPreview
		p.text = label_text
		p.font = render.label_font
		p.font_size = label_size
		p.rot_deg = label_rotation_deg
		p.fill_color = render.label_color
		p.outline_color = Color(1, 1, 1, 1)
		p.queue_redraw()
```
