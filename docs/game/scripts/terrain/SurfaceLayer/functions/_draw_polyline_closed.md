# SurfaceLayer::_draw_polyline_closed Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 479–486)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void
```

## Description

Draws a closed polyline with optional last segment if not already closed

## Source

```gdscript
func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2:
		return
	draw_polyline(pts, color, width, antialias)
	if pts[0].distance_to(pts[pts.size() - 1]) > 1e-5:
		draw_line(pts[pts.size() - 1], pts[0], color, width, antialias)
```
