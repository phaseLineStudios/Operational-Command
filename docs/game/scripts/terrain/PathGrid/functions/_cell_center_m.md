# PathGrid::_cell_center_m Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 715–718)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _cell_center_m(c: Vector2i) -> Vector2
```

## Source

```gdscript
func _cell_center_m(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * cell_size_m, (c.y + 0.5) * cell_size_m)
```
