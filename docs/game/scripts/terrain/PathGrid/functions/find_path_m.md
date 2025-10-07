# PathGrid::find_path_m Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 413–426)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array
```

## Description

Find a path (meters) for a profile. Returns PackedVector2Array world positions (m)

## Source

```gdscript
func find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array:
	var a := _to_cell(start_m)
	var b := _to_cell(goal_m)
	if not _in_bounds(a) or not _in_bounds(b):
		return PackedVector2Array()

	var cells := _astar.get_id_path(a, b)
	var out := PackedVector2Array()
	out.resize(cells.size())
	for i in cells.size():
		out[i] = _cell_center_m(cells[i])
	return out
```
