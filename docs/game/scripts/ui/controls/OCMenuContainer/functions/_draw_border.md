# OCMenuContainer::_draw_border Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContainer.gd` (lines 112–124)</br>
*Belongs to:* [OCMenuContainer](../../OCMenuContainer.md)

**Signature**

```gdscript
func _draw_border()
```

## Source

```gdscript
func _draw_border():
	var grid_size: Vector2 = size - Vector2(padding.x + padding.z, padding.y + padding.w)
	var top_left := Vector2(padding.x, padding.y)
	var top_right := top_left + Vector2(grid_size.x, 0)
	var bottom_left := top_left + Vector2(0, grid_size.y)
	var bottom_right := bottom_left + Vector2(grid_size.x, 0)

	draw_line(top_left, bottom_left, border_color, border_width.x)
	draw_line(top_left, top_right, border_color, border_width.y)
	draw_line(top_right, bottom_right, border_color, border_width.z)
	draw_line(bottom_left, bottom_right, border_color, border_width.w)
```
