# TerrainPointTool::_draw Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 293–301)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
	func _draw() -> void:
		if tex == null:
			return
		var sc: float = max(0.01, scale_factor)
		var t_size: Vector2 = Vector2(brush.symbol_size_m, brush.symbol_size_m) * sc
		var top_left := -t_size * 0.5
		draw_set_transform(Vector2.ZERO, deg_to_rad(rotation_deg), Vector2.ONE)
		draw_texture_rect(tex, Rect2(top_left, t_size), false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
