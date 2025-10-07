# GridLayer::_draw_h_line Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 115–121)</br>
*Belongs to:* [GridLayer](../../GridLayer.md)

**Signature**

```gdscript
func _draw_h_line(img: Image, y: int, lw: float, c: Color) -> void
```

## Source

```gdscript
func _draw_h_line(img: Image, y: int, lw: float, c: Color) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var half := int(floor(max(1.0, lw) * 0.5))
	for yy in range(max(0, y - half), min(h, y + half + 1)):
		for xx in w:
			img.set_pixel(xx, yy, c)
```
