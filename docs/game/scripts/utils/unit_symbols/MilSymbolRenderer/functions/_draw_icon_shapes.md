# MilSymbolRenderer::_draw_icon_shapes Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 270–301)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_icon_shapes(shapes: Array, color: Color) -> void
```

## Description

Draw icon as shapes

## Source

```gdscript
func _draw_icon_shapes(shapes: Array, color: Color) -> void:
	for shape_data in shapes:
		if not shape_data is Dictionary:
			continue

		var shape_type: String = shape_data.get("shape", "")
		var filled: bool = shape_data.get("filled", false)

		match shape_type:
			"circle":
				var center: Vector2 = shape_data.get("center", Vector2.ZERO)
				var radius: float = shape_data.get("radius", 10.0)
				if filled:
					draw_circle(center, radius, color)
				else:
					draw_arc(center, radius, 0, TAU, 32, color, config.stroke_width * 0.75)
			"rect":
				var rect: Rect2 = shape_data.get("rect", Rect2(0, 0, 10, 10))
				var r: float = float(shape_data.get("corner_radius", shape_data.get("radius", 0.0)))
				var segs: int = int(shape_data.get("segments", 10))
				if r > 0.0:
					_draw_rounded_rect(rect, r, color, filled, config.stroke_width * 0.75, segs)
				else:
					if filled:
						draw_rect(rect, color)
					else:
						draw_rect(rect, color, false, config.stroke_width * 0.75)
			"oval":
				var rect: Rect2 = shape_data.get("rect", Rect2(0, 0, 20, 10))
				_draw_oval(rect, color, filled)
```
