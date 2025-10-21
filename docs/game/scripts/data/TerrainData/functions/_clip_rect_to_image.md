# TerrainData::_clip_rect_to_image Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 406–417)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i
```

## Description

Helper function to clip a rect to image bounds

## Source

```gdscript
static func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i:
	var w := img.get_width()
	var h := img.get_height()
	if w <= 0 or h <= 0:
		return Rect2i()
	var x0: int = clamp(rect.position.x, 0, w)
	var y0: int = clamp(rect.position.y, 0, h)
	var x1: int = clamp(rect.position.x + rect.size.x, 0, w)
	var y1: int = clamp(rect.position.y + rect.size.y, 0, h)
	return Rect2i(Vector2i(x0, y0), Vector2i(max(0, x1 - x0), max(0, y1 - y0)))
```
