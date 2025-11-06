# OCMenuContainer::_draw_grid Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContainer.gd` (lines 94–111)</br>
*Belongs to:* [OCMenuContainer](../../OCMenuContainer.md)

**Signature**

```gdscript
func _draw_grid() -> void
```

## Source

```gdscript
func _draw_grid() -> void:
	if not grid_enabled:
		return
	var grid_size: Vector2 = size - Vector2(padding.x + padding.z, padding.y + padding.w)
	var grid_tl: Vector2 = Vector2(padding.x, padding.y)

	var cols: int = int(ceil(grid_size.x / cell_size.x))
	var rows: int = int(ceil(grid_size.y / cell_size.y))

	for i in range(cols + 1):
		var x := grid_tl.x + i * cell_size.x
		draw_line(Vector2(x, grid_tl.y), Vector2(x, grid_tl.y + grid_size.y), line_color)

	for j in range(rows + 1):
		var y := grid_tl.y + j * cell_size.y
		draw_line(Vector2(grid_tl.x, y), Vector2(grid_tl.x + grid_size.x, y), line_color)
```
