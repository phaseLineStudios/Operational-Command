# TerrainPointTool::_update_preview_appearance Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 129–140)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _update_preview_appearance() -> void
```

## Source

```gdscript
func _update_preview_appearance() -> void:
	if _preview == null:
		return
	if _preview is SymbolPreview:
		var sp := _preview as SymbolPreview
		sp.tex = (active_brush.symbol if active_brush and active_brush.symbol else null)
		sp.scale_factor = symbol_scale
		sp.rotation_deg = symbol_rotation_deg
		sp.brush = active_brush
		sp.queue_redraw()
```
