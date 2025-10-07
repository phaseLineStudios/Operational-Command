# MovementAgent::_draw_cell_rect_m Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 291–304)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _draw_cell_rect_m(rm: Rect2, col: Color, width: float, filled := false) -> void
```

## Source

```gdscript
func _draw_cell_rect_m(rm: Rect2, col: Color, width: float, filled := false) -> void:
	var p0 := _to_local_from_terrain(rm.position)
	var p1 := _to_local_from_terrain(rm.position + Vector2(rm.size.x, 0))
	var p2 := _to_local_from_terrain(rm.position + rm.size)
	var p3 := _to_local_from_terrain(rm.position + Vector2(0, rm.size.y))
	if filled:
		draw_colored_polygon(PackedVector2Array([p0, p1, p2, p3]), col)
	else:
		draw_line(p0, p1, col, width)
		draw_line(p1, p2, col, width)
		draw_line(p2, p3, col, width)
		draw_line(p3, p0, col, width)
```
