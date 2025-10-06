# PathGrid::rebuild Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 112–211)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func rebuild(profile: int) -> void
```

## Description

Build/rebuild grid for a movement profile

## Source

```gdscript
func rebuild(profile: int) -> void:
	if data == null:
		push_warning("PathGrid: no TerrainData.")
		return

	_collect_features()
	_cols = int(ceil(float(data.width_m) / cell_size_m))
	_rows = int(ceil(float(data.height_m) / cell_size_m))

	var key := _astar_key(profile)
	if _astar_cache.has(key):
		_astar = _astar_cache[key]
		emit_signal("grid_rebuilt")
		emit_signal("build_ready", profile)
		return

	_prepare_slope_cache()
	_prepare_line_dist_cache()

	if _build_running:
		_build_cancel = true
		await get_tree().process_frame

	var elev_img := data.elevation
	var elev_copy := Image.new()
	if elev_img and not elev_img.is_empty():
		elev_copy = elev_img.duplicate()

	var areas := []
	for it in _area_features:
		(
			areas
			. append(
				{
					"poly": it.poly,
					"mv":
					{
						"t": it.brush.mv_tracked,
						"w": it.brush.mv_wheeled,
						"f": it.brush.mv_foot,
						"r": it.brush.mv_riverine,
					},
					"z": it.brush.z_index
				}
			)
		)

	var lines := []
	for it in _line_features:
		(
			lines
			. append(
				{
					"pts": it.pts,
					"mv":
					{
						"t": it.brush.mv_tracked,
						"w": it.brush.mv_wheeled,
						"f": it.brush.mv_foot,
						"r": it.brush.mv_riverine,
					},
					"road_bias": it.brush.road_bias,
					"width_px": float(it.get("width_px", 0.0)),
					"aabb": it.aabb,
					"bridge_cap": float(it.brush.bridge_capacity_tons)
				}
			)
		)

	var snap := {
		"cols": _cols,
		"rows": _rows,
		"cell": float(cell_size_m),
		"base_elev": float(data.base_elevation_m),
		"areas": areas,
		"lines": lines,
		"line_r": float(line_influence_radius_m),
		"slopeK": float(slope_multiplier_per_grade),
		"maxGrade": float(max_traversable_grade),
		"allow_diag": bool(allow_diagonals),
		"profile": profile,
		"road_bias_weight": float(road_bias_weight),
		"zero_blocks": bool(zero_multiplier_blocks),
		"elev": elev_copy,
		"elev_res_m": int(data.elevation_resolution_m),
		"key": key,
	}

	_build_cancel = false
	_build_running = true
	_build_profile = profile as TerrainBrush.MoveProfile
	emit_signal("build_started", profile)

	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null
	_build_thread = Thread.new()
	_build_thread.start(Callable(self, "_thread_build").bind(snap), Thread.PRIORITY_LOW)
```
