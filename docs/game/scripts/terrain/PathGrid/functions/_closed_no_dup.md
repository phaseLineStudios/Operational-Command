# PathGrid::_closed_no_dup Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 870–876)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _closed_no_dup(pts: PackedVector2Array) -> PackedVector2Array
```

## Source

```gdscript
static func _closed_no_dup(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array(pts)
	if out.size() >= 2 and out[0].distance_squared_to(out[out.size() - 1]) < 1e-9:
		out.remove_at(out.size() - 1)
	return out
```
