# LineLayer::_draw_polyline_solid Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 267–272)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

**Signature**

```gdscript
func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void
```

## Description

Draw a solid polyline

## Source

```gdscript
func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2:
		return
	draw_polyline(pts, color, width, antialias)
```
