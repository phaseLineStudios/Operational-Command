# PathGrid::debug_slope_mult_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 753–759)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func debug_slope_mult_cell(c: Vector2i) -> float
```

## Description

Slope multiplier at cell (uses cache if present).

## Source

```gdscript
func debug_slope_mult_cell(c: Vector2i) -> float:
	var key := _raster_key("slope")
	if _slope_cache.has(key):
		return _slope_cache[key][c.y * _cols + c.x]
	return _slope_multiplier_at_cell(c.x, c.y)
```
