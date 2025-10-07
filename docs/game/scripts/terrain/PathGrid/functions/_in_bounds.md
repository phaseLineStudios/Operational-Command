# PathGrid::_in_bounds Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 719–722)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _in_bounds(c: Vector2i) -> bool
```

## Source

```gdscript
func _in_bounds(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < _cols and c.y < _rows
```
