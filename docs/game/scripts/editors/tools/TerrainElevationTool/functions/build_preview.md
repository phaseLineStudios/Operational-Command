# TerrainElevationTool::build_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 25–37)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

## Source

```gdscript
func build_preview(overlay_parent: Node) -> Control:
	var p := BrushPreviewCircle.new()
	p.meters_per_pixel = meters_per_pixel
	p.radius_m = brush_radius_m
	p.falloff = falloff_p
	p.strength_m = strength_m
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.pivot_offset = Vector2.ZERO
	p.z_index = 100
	overlay_parent.add_child(p)
	return p
```
