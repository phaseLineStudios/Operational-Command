# MovementAgent::_debug_cell_rect_world Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 167–173)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _debug_cell_rect_world(c: Vector2i) -> Rect2
```

## Description

Get a Rect2 (in *world meters*) for a cell id.

## Source

```gdscript
func _debug_cell_rect_world(c: Vector2i) -> Rect2:
	if grid == null or c.x < 0:
		return Rect2()
	var cs := grid.cell_size_m
	return Rect2(Vector2(c.x * cs, c.y * cs), Vector2(cs, cs))
```
