# PathGrid::_to_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 709–714)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _to_cell(p_m: Vector2) -> Vector2i
```

## Source

```gdscript
func _to_cell(p_m: Vector2) -> Vector2i:
	var cx: int = clamp(int(floor(p_m.x / cell_size_m)), 0, _cols - 1)
	var cy: int = clamp(int(floor(p_m.y / cell_size_m)), 0, _rows - 1)
	return Vector2i(cx, cy)
```
