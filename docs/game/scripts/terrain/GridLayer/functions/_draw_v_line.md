# GridLayer::_draw_v_line Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 106–114)</br>
*Belongs to:* [GridLayer](../../GridLayer.md)

**Signature**

```gdscript
func _draw_v_line(img: Image, x: int, lw: float, c: Color) -> void
```

## Source

```gdscript
func _draw_v_line(img: Image, x: int, lw: float, c: Color) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var half := int(floor(max(1.0, lw) * 0.5))
	for xx in range(max(0, x - half), min(w, x + half + 1)):
		for yy in h:
			img.set_pixel(xx, yy, c)
```
