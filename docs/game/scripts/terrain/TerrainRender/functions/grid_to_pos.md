# TerrainRender::grid_to_pos Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 335–380)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func grid_to_pos(grid: String) -> Vector2
```

## Description

API to get terrain local position from grid number

## Source

```gdscript
func grid_to_pos(grid: String) -> Vector2:
	var digits := ""
	for ch in grid:
		if ch.is_valid_int():
			digits += ch

	if digits.length() % 2 != 0:
		LogService.warning(
			"Grid label must have an even number of digits (6/8/10). Got: %s" % grid,
			"TerrainRender.gd:341"
		)
		return Vector2i.ZERO

	@warning_ignore("integer_division")
	var half := digits.length() / 2
	if half < 3 or half > 5:
		LogService.warning(
			"Grid label must be 6, 8, or 10 digits (got %d)." % digits.length(),
			"TerrainRender.gd:341"
		)
		return Vector2i.ZERO

	var east_str := digits.substr(0, half)
	var north_str := digits.substr(half, half)

	var gx_abs := east_str.substr(0, 3).to_int()
	var gy_abs := north_str.substr(0, 3).to_int()

	var cell_x := gx_abs - data.grid_start_x
	var cell_y := gy_abs - data.grid_start_y

	var x := cell_x * 100
	var y := cell_y * 100

	var extra_len := half - 3
	if extra_len > 0:
		var sub_x_str := east_str.substr(3, extra_len)
		var sub_y_str := north_str.substr(3, extra_len)

		var step := int(round(100 / pow(10.0, extra_len)))
		x += (0 if sub_x_str.is_empty() else sub_x_str.to_int()) * step
		y += (0 if sub_y_str.is_empty() else sub_y_str.to_int()) * step

	return Vector2i(x + 50, y + 50)
```
