# TerrainPolygonTool::build_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 88–103)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

## Source

```gdscript
func build_preview(overlay_parent: Node) -> Control:
	_preview = HandlesOverlay.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.anchor_left = 0
	_preview.anchor_top = 0
	_preview.anchor_right = 1
	_preview.anchor_bottom = 1
	_preview.offset_left = 0
	_preview.offset_top = 0
	_preview.offset_right = 0
	_preview.offset_bottom = 0
	(_preview as HandlesOverlay).tool = self
	overlay_parent.add_child(_preview)
	return _preview
```
