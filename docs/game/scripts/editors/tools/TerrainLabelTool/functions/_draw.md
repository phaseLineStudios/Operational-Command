# TerrainLabelTool::_draw Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 247–276)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
	func _draw() -> void:
		if font == null or text == "":
			return

		var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var ascent := font.get_ascent(font_size)
		var height := font.get_height(font_size)

		var baseline := Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)

		var ang := deg_to_rad(rot_deg)
		draw_set_transform(Vector2.ZERO, ang, Vector2.ONE)

		var offs := [
			Vector2(-1, 0),
			Vector2(1, 0),
			Vector2(0, -1),
			Vector2(0, 1),
			Vector2(-1, -1),
			Vector2(1, -1),
			Vector2(-1, 1),
			Vector2(1, 1)
		]
		for o in offs:
			draw_string(
				font, baseline + o, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, outline_color
			)
		draw_string(font, baseline, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, fill_color)

		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
