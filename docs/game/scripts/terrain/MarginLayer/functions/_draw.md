# MarginLayer::_draw Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 112–194)</br>
*Belongs to:* [MarginLayer](../../MarginLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	var margin_sb := StyleBoxFlat.new()
	margin_sb.bg_color = margin_color
	margin_sb.content_margin_top = margin_top_px
	margin_sb.content_margin_bottom = margin_bottom_px
	margin_sb.content_margin_left = margin_left_px
	margin_sb.content_margin_right = margin_right_px
	add_theme_stylebox_override("panel", margin_sb)

	if data == null or label_font == null:
		return

	var sb := get_theme_stylebox("panel")
	var l := 0.0
	var t := 0.0
	if sb:
		l = sb.get_content_margin(SIDE_LEFT)
		t = sb.get_content_margin(SIDE_TOP)

	var map_left := l + base_border_px
	var map_top := t + base_border_px
	var map_w := float(data.width_m) - base_border_px * 2.0
	var map_h := float(data.height_m) - base_border_px * 2.0
	var map_right := map_left + map_w
	var map_bottom := map_top + map_h

	var ascent: float
	var height: float
	if data.name != "":
		var center_x := 0.5 * (map_left + map_right)
		ascent = label_font.get_ascent(label_size)
		height = label_font.get_height(label_size)
		var y_mid := 0.5 + height
		var baseline_y := y_mid + (ascent - 0.5 * height)

		_draw_text_center(str(data.name), Vector2(center_x, baseline_y), title_size)

	var start_x := 0
	var start_y := 0
	if data.has_method("get"):
		if data.has_method("_get") or true:
			if "grid_start_x" in data:
				start_x = int(data.grid_start_x)
			if "grid_start_y" in data:
				start_y = int(data.grid_start_y)

	var every := float(max(1, margin_label_every_m))
	ascent = label_font.get_ascent(label_size)
	height = label_font.get_height(label_size)

	if every > 0.0 and (show_top or show_bottom):
		var i := 0
		while true:
			var m := i * every
			if m > map_w:
				break
			var screen_x := map_left + m
			var num := str(start_x + i)
			if show_top:
				_draw_text_center(num, Vector2(screen_x, map_top - ascent + offset_top_px))
			if show_bottom:
				_draw_text_center(num, Vector2(screen_x, map_bottom + ascent + offset_bottom_px))
			i += 1

	if every > 0.0 and (show_left or show_right):
		var j := 0
		while true:
			var m2 := j * every
			if m2 > map_h:
				break
			var screen_y := map_top + m2
			var num2 := str(start_y + j)
			if show_left:
				_draw_text_middle(
					num2, Vector2(map_left + offset_left_px, screen_y), true, ascent, height
				)
			if show_right:
				_draw_text_middle(
					num2, Vector2(map_right + offset_right_px, screen_y), false, ascent, height
				)
			j += 1
```
