# MovementAgent::_draw Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 97–192)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if not debug_draw:
		return

	if debug_show_path and _path.size() >= 2:
		for i in range(1, _path.size()):
			var a := _to_local_from_terrain(_path[i - 1])
			var b := _to_local_from_terrain(_path[i])
			draw_line(a, b, Color(0.08, 0.08, 0.08, 1), 1.5)
			draw_circle(b, debug_marker_r_m, Color(0.0, 0.7, 0.0, 0.9))
		if _path_idx < _path.size():
			draw_circle(
				_to_local_from_terrain(_path[_path_idx]),
				debug_marker_r_m,
				Color(1.0, 0.45, 0.1, 0.9)
			)

	if debug_show_cells and grid:
		var cur := grid.world_to_cell(sim_pos_m)
		if grid._in_bounds(cur):
			_draw_cell_rect_m(
				Rect2(Vector2(cur.x, cur.y) * grid.cell_size_m, Vector2.ONE * grid.cell_size_m),
				Color(0.15, 0.55, 1.0, 0.35),
				2.0,
				false
			)
		if _path_idx < _path.size():
			var nxt := grid.world_to_cell(_path[_path_idx])
			if grid._in_bounds(nxt):
				_draw_cell_rect_m(
					Rect2(Vector2(nxt.x, nxt.y) * grid.cell_size_m, Vector2.ONE * grid.cell_size_m),
					Color(1.0, 0.4, 0.1, 0.35),
					2.0,
					false
				)

	if debug_show_vectors:
		var base_m := sim_pos_m
		var heading := Vector2.RIGHT.rotated(rotation) * (debug_marker_r_m * 3.0)
		draw_line(
			_to_local_from_terrain(base_m),
			_to_local_from_terrain(base_m + heading),
			Color(0.2, 0.6, 1.0, 0.8),
			2.0
		)
		if _trail.size() >= 2:
			var v: Vector2 = (_trail[_trail.size() - 1] - _trail[_trail.size() - 2]).limit_length(
				debug_marker_r_m * 4.0
			)
			draw_line(
				_to_local_from_terrain(base_m),
				_to_local_from_terrain(base_m + v),
				Color(0.2, 1.0, 0.2, 0.8),
				2.0
			)

	if _trail.size() >= 2:
		for i in range(1, _trail.size()):
			draw_line(
				_to_local_from_terrain(_trail[i - 1]),
				_to_local_from_terrain(_trail[i]),
				Color(0.0, 0.0, 0.0, 0.25),
				1.0
			)

	if debug_show_hud:
		var hud_anchor_m := sim_pos_m
		var hud_local := _to_local_from_terrain(hud_anchor_m) + Vector2(8, -12)

		var font := ThemeDB.fallback_font
		var fsize := ThemeDB.fallback_font_size
		var w := _debug_weight_here()
		var eta := eta_seconds()
		var inst_v := _debug_instant_speed(get_process_delta_time())
		var txt := (
			"w=%.2f  v=%.1f/%.1f m/s  ETA=%.1fs  idx:%d/%d"
			% [
				w if w < INF else -1.0,
				inst_v,
				base_speed_mps / (w if w < INF else 1.0),
				eta,
				_path_idx,
				_path.size()
			]
		)

		draw_set_transform(hud_local, -rotation, Vector2.ONE)
		draw_string(
			font, Vector2(1, 1), txt, HORIZONTAL_ALIGNMENT_LEFT, -1.0, fsize, Color(0, 0, 0, 0.8)
		)
		draw_string(
			font, Vector2.ZERO, txt, HORIZONTAL_ALIGNMENT_LEFT, -1.0, fsize, Color(1, 1, 1, 0.95)
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
