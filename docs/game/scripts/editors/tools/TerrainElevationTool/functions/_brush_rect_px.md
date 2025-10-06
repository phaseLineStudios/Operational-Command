# TerrainElevationTool::_brush_rect_px Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 236–248)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func _brush_rect_px(center_px: Vector2i, r_px: int, img: Image) -> Rect2i
```

## Description

Helper function to get brush rect

## Source

```gdscript
func _brush_rect_px(center_px: Vector2i, r_px: int, img: Image) -> Rect2i:
	var p := Vector2i(center_px.x - r_px, center_px.y - r_px)
	var s := Vector2i(r_px * 2 + 1, r_px * 2 + 1)
	var rect := Rect2i(p, s)
	var w := img.get_width()
	var h := img.get_height()
	var x: int = clamp(rect.position.x, 0, w)
	var y: int = clamp(rect.position.y, 0, h)
	var rw: int = clamp(rect.size.x - (x - rect.position.x), 0, w - x)
	var rh: int = clamp(rect.size.y - (y - rect.position.y), 0, h - y)
	return Rect2i(Vector2i(x, y), Vector2i(rw, rh))
```
