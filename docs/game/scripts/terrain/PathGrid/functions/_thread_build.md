# PathGrid::_thread_build Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 213–358)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _thread_build(snap: Dictionary) -> void
```

## Description

Internal: worker function (runs off the main thread)

## Source

```gdscript
func _thread_build(snap: Dictionary) -> void:
	var cols := int(snap.cols)
	var rows := int(snap.rows)
	var cell := float(snap.cell)

	var weights := PackedFloat32Array()
	weights.resize(cols * rows)
	var solids := PackedByteArray()
	solids.resize(cols * rows)

	var elev_at_m = func(p: Vector2) -> float:
		var img: Image = snap.elev
		if img == null or img.is_empty():
			return float(snap.base_elev)
		var px := Vector2i(
			clampi(int(round(p.x / snap.elev_res_m)), 0, img.get_width() - 1),
			clampi(int(round(p.y / snap.elev_res_m)), 0, img.get_height() - 1)
		)
		return img.get_pixel(px.x, px.y).r + float(snap.base_elev)

	var slope_mult_at = func(cx: int, cy: int) -> float:
		var p := Vector2((cx + 0.5) * cell, (cy + 0.5) * cell)
		var sx := cell * 0.5
		var sy := cell * 0.5
		var e_l: float = elev_at_m.call(p - Vector2(sx, 0))
		var e_r: float = elev_at_m.call(p + Vector2(sx, 0))
		var e_u: float = elev_at_m.call(p - Vector2(0, sy))
		var e_d: float = elev_at_m.call(p + Vector2(0, sy))
		var dx: float = (e_r - e_l) / max(cell, 0.001)
		var dy: float = (e_d - e_u) / max(cell, 0.001)
		var grade := sqrt(dx * dx + dy * dy)
		if grade >= float(snap.maxGrade):
			return INF
		return 1.0 + float(snap.slopeK) * grade

	var mv_mult_area_at = func(p: Vector2) -> float:
		var best := 1.0
		var best_z := -INF
		for it in snap.areas:
			var aabb: Rect2 = _poly_bounds(it.poly)
			if not aabb.has_point(p):
				continue
			if Geometry2D.is_point_in_polygon(p, it.poly):
				var z := int(it.z)
				if z > best_z:
					best_z = z
					match int(snap.profile):
						TerrainBrush.MoveProfile.TRACKED:
							best = max(float(it.mv.t), 0.0)
						TerrainBrush.MoveProfile.WHEELED:
							best = max(float(it.mv.w), 0.0)
						TerrainBrush.MoveProfile.FOOT:
							best = max(float(it.mv.f), 0.0)
						TerrainBrush.MoveProfile.RIVERINE:
							best = max(float(it.mv.r), 0.0)
		return best

	var mv_mult_line_at = func(p: Vector2) -> Dictionary:
		var mult := 1.0
		var pref := 1.0
		var has_bridge := false
		var hit := false
		for it in snap.lines:
			var aabb: Rect2 = it.aabb
			if not aabb.has_point(p):
				continue
			var eff_r_m: float = (
				float(snap.line_r)
				if float(snap.line_r) > 0.0
				else max(0.0, float(it.width_px) * 0.5)
			)
			var d := _dist_point_polyline(p, it.pts)
			if d <= eff_r_m:
				hit = true
				match int(snap.profile):
					TerrainBrush.MoveProfile.TRACKED:
						mult = min(mult, max(float(it.mv.t), 0.0))
					TerrainBrush.MoveProfile.WHEELED:
						mult = min(mult, max(float(it.mv.w), 0.0))
					TerrainBrush.MoveProfile.FOOT:
						mult = min(mult, max(float(it.mv.f), 0.0))
					TerrainBrush.MoveProfile.RIVERINE:
						mult = min(mult, max(float(it.mv.r), 0.0))
				pref = min(pref, max(0.05, float(it.road_bias)))
				if float(it.get("bridge_cap", 0.0)) > 0.0:
					has_bridge = true
		return {"m": mult, "pref": pref, "bridge": has_bridge, "hit": hit}

	for cy in rows:
		if _build_cancel:
			_call_main("_thread_finish", null, "cancelled")
			return
		for cx in cols:
			var idx := cy * cols + cx
			var pos := Vector2((cx + 0.5) * cell, (cy + 0.5) * cell)

			var area_m: float = mv_mult_area_at.call(pos)
			var line_res: Dictionary = mv_mult_line_at.call(pos)
			var slope_mult: float = slope_mult_at.call(cx, cy)
			var on_bridge := (
				bool(line_res.bridge) and int(snap.profile) != TerrainBrush.MoveProfile.RIVERINE
			)

			if not on_bridge and bool(snap.zero_blocks) and area_m <= 0.0:
				solids[idx] = 1
				weights[idx] = 1.0
				continue
			if slope_mult >= INF:
				solids[idx] = 1
				weights[idx] = 1.0
				continue

			var mv_mult: float = (
				float(line_res.m)
				if on_bridge
				else (min(area_m, float(line_res.m)) if bool(line_res.hit) else area_m)
			)
			var road_pref := mix(
				1.0, float(line_res.pref), clamp(float(snap.road_bias_weight), 0.0, 1.0)
			)

			var w := mv_mult * slope_mult * road_pref
			if w >= 1e6:
				solids[idx] = 1
				weights[idx] = 1.0
			else:
				solids[idx] = 0
				weights[idx] = clamp(w, 0.001, 1e4)

		if cy % 8 == 0:
			_call_main("_emit_build_progress", float(cy) / float(rows))

	_call_main(
		"_thread_finish",
		{
			"weights": weights,
			"solids": solids,
			"profile": int(snap.profile),
			"cols": cols,
			"rows": rows,
			"key": String(snap.key),
		},
		""
	)
```
