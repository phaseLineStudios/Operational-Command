# PathGrid::_line_px_to_meters Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 603–606)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _line_px_to_meters(width_px: float) -> float
```

## Source

```gdscript
func _line_px_to_meters(width_px: float) -> float:
	return max(0.0, width_px)
```
