# PathGrid::_weight_for_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 498–550)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _weight_for_cell(cx: int, cy: int, profile: int, _r_solid: bool) -> float
```

## Source

```gdscript
func _weight_for_cell(cx: int, cy: int, profile: int, _r_solid: bool) -> float:
	var pos_m := _cell_center_m(Vector2i(cx, cy))
	var surface_mult := _surface_multiplier_at(pos_m, profile)

	var on_bridge := false
	var line_mult := 1.0
	var pref := 1.0
	var hit := false
	for it in _line_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(pos_m):
			continue
		var eff_r_m := (
			line_influence_radius_m
			if line_influence_radius_m > 0.0
			else _line_px_to_meters(float(it.width_px)) * 0.5
		)
		var d := _dist_point_polyline(pos_m, it.pts)
		if d <= eff_r_m:
			hit = true
			if (
				float(it.get("bridge_cap", 0.0)) > 0.0
				and profile != TerrainBrush.MoveProfile.RIVERINE
			):
				on_bridge = true
			line_mult = min(line_mult, max(it.brush.movement_multiplier(profile), 0.0))
			pref = min(pref, max(0.05, it.brush.road_bias))

	if not on_bridge and zero_multiplier_blocks and surface_mult <= 0.0:
		_r_solid = true
		return 1.0

	var sl_key := _raster_key("slope")
	var slope_mult: float = (
		_slope_cache[sl_key][cy * _cols + cx]
		if _slope_cache.has(sl_key)
		else _slope_multiplier_at_cell(cx, cy)
	)
	if slope_mult >= INF:
		_r_solid = true
		return 1.0

	var mv_mult: float = (
		line_mult if on_bridge else (min(surface_mult, line_mult) if hit else surface_mult)
	)
	var road_pref := mix(1.0, pref, clamp(road_bias_weight, 0.0, 1.0))
	var w := mv_mult * slope_mult * road_pref * road_pref
	if w >= 1e6:
		_r_solid = true
		return 1.0
	return clamp(w, 0.001, 1e4)
```
