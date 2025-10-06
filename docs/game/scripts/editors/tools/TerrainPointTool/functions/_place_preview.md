# TerrainPointTool::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 118–127)</br>
*Belongs to:* [TerrainPointTool](../TerrainPointTool.md)

**Signature**

```gdscript
func _place_preview(local_px: Vector2) -> void
```

## Source

```gdscript
func _place_preview(local_px: Vector2) -> void:
	if _preview == null:
		return
	_preview.position = local_px
	_preview.visible = (
		_preview is SymbolPreview and (active_brush != null and active_brush.symbol != null)
	)
	_preview.queue_redraw()
```
