# TerrainLabelTool::build_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 20–28)</br>
*Belongs to:* [TerrainLabelTool](../TerrainLabelTool.md)

**Signature**

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

## Source

```gdscript
func build_preview(overlay_parent: Node) -> Control:
	_preview = LabelPreview.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.z_index = 100
	overlay_parent.add_child(_preview)
	_refresh_preview()
	return _preview
```
