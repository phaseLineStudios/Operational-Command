# GridLayer::_bake_grid_texture Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 56–105)</br>
*Belongs to:* [GridLayer](../GridLayer.md)

**Signature**

```gdscript
func _bake_grid_texture() -> void
```

## Source

```gdscript
func _bake_grid_texture() -> void:
	_need_bake = false
	var w := int(max(1.0, size.x))
	var h := int(max(1.0, size.y))
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))

	var step := 100.0
	var thick_every := 1000.0
	var odd_align = func(lw: float) -> float: return 0.5 if (int(round(lw)) % 2 != 0) else 0.0

	var x := 0.0
	while x < w:
		var thick := fmod(x + 0.0001, thick_every) < 0.2
		var col := grid_1km_color if thick else grid_100m_color
		var lw := grid_1km_line_px if thick else grid_line_px
		var off: float = odd_align.call(lw)
		_draw_v_line(img, int(x + off), lw, col)
		x += step

	var rx := w - 1.0
	var thick_r := fmod(rx + 0.0001, thick_every) < 0.2
	_draw_v_line(
		img,
		int(rx + odd_align.call(grid_1km_line_px if thick_r else grid_line_px)),
		grid_1km_line_px if thick_r else grid_line_px,
		grid_1km_color if thick_r else grid_100m_color
	)

	var y := 0.0
	while y < h:
		var thick_y := fmod(y + 0.0001, thick_every) < 0.2
		var col_y := grid_1km_color if thick_y else grid_100m_color
		var lw_y := grid_1km_line_px if thick_y else grid_line_px
		var off_y: float = odd_align.call(lw_y)
		_draw_h_line(img, int(y + off_y), lw_y, col_y)
		y += step

	var by := h - 1.0
	var thick_b := fmod(by + 0.0001, thick_every) < 0.2
	_draw_h_line(
		img,
		int(by + odd_align.call(grid_1km_line_px if thick_b else grid_line_px)),
		grid_1km_line_px if thick_b else grid_line_px,
		grid_1km_color if thick_b else grid_100m_color
	)

	_grid_tex = ImageTexture.create_from_image(img)
```
