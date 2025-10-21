# TerrainElevationTool::_rect_union Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 227–234)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func _rect_union(a: Rect2i, b: Rect2i) -> Rect2i
```

## Description

Helper function to union join a rect

## Source

```gdscript
func _rect_union(a: Rect2i, b: Rect2i) -> Rect2i:
	var x0 = min(a.position.x, b.position.x)
	var y0 = min(a.position.y, b.position.y)
	var x1 = max(a.position.x + a.size.x, b.position.x + b.size.x)
	var y1 = max(a.position.y + a.size.y, b.position.y + b.size.y)
	return Rect2i(Vector2i(x0, y0), Vector2i(max(0, x1 - x0), max(0, y1 - y0)))
```
