# TerrainElevationTool::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 38–49)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func _place_preview(local_px: Vector2) -> void
```

## Source

```gdscript
func _place_preview(local_px: Vector2) -> void:
	if _preview is Control:
		var p := _preview as Control
		p.position = local_px
		if p is BrushPreviewCircle:
			(p as BrushPreviewCircle).radius_m = brush_radius_m
			(p as BrushPreviewCircle).falloff = falloff_p
			(p as BrushPreviewCircle).strength_m = strength_m
		p.visible = true
		p.queue_redraw()
```
