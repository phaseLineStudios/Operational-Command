# TerrainRender::pos_to_grid Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 297–333)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func pos_to_grid(pos: Vector2, total_digits: int = 6) -> String
```

## Description

API to get grid number from terrain local position

## Source

```gdscript
func pos_to_grid(pos: Vector2, total_digits: int = 6) -> String:
	@warning_ignore("integer_division")
	var per_axis := total_digits / 2
	if per_axis != 3 and per_axis != 4 and per_axis != 5:
		push_warning(
			"pos_to_grid: total_digits must be 6, 8, or 10; got %d. Using 6." % total_digits
		)
		per_axis = 3

	var cell_x := floori(pos.x / GRID_SIZE_M)
	var cell_y := floori(pos.y / GRID_SIZE_M)

	var base_x := data.grid_start_x + cell_x
	var base_y := data.grid_start_y + cell_y

	var off_x := clampf(pos.x - float(cell_x) * GRID_SIZE_M, 0.0, 99.9999)
	var off_y := clampf(pos.y - float(cell_y) * GRID_SIZE_M, 0.0, 99.9999)

	var east: int
	var north: int

	match per_axis:
		3:
			east = base_x
			north = base_y
		4:
			east = base_x * 10 + int(floor(off_x / 10.0))
			north = base_y * 10 + int(floor(off_y / 10.0))
		5:
			east = base_x * 100 + int(floor(off_x))
			north = base_y * 100 + int(floor(off_y))

	var e_str := str(east).pad_zeros(per_axis)
	var n_str := str(north).pad_zeros(per_axis)
	return e_str + n_str
```
