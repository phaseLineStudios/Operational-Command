# TerrainPointTool::build_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 109–118)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

## Source

```gdscript
func build_preview(overlay_parent: Node) -> Control:
	_preview = SymbolPreview.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.brush = active_brush
	_preview.z_index = 100
	overlay_parent.add_child(_preview)
	_update_preview_appearance()
	return _preview
```
