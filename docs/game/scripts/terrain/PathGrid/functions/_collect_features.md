# PathGrid::_collect_features Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 656–708)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _collect_features() -> void
```

## Source

```gdscript
func _collect_features() -> void:
	_area_features.clear()
	_line_features.clear()
	if data == null:
		return

	for s in data.surfaces:
		if typeof(s) != TYPE_DICTIONARY:
			continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null:
			continue
		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue
		if (
			bool(s.get("closed", true))
			and pts.size() >= 2
			and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-9
		):
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue
		var poly := pts
		var aabb := _poly_bounds(poly)
		_area_features.append({"poly": poly, "brush": brush, "aabb": aabb})

	for l in data.lines:
		if typeof(l) != TYPE_DICTIONARY:
			continue
		var brush: TerrainBrush = l.get("brush", null)
		if brush == null:
			continue
		var pts: PackedVector2Array = l.get("points", PackedVector2Array())
		if pts.size() < 2:
			continue
		var aabb := _polyline_bounds(pts)
		aabb = aabb.grow(
			max(line_influence_radius_m, _line_px_to_meters(l.get("width_px", 0.0)) * 0.5)
		)
		_line_features.append(
			{
				"pts": pts,
				"brush": brush,
				"aabb": aabb,
				"width_px": float(l.get("width_px", 0.0)),
				"bridge_cap": float(brush.bridge_capacity_tons)
			}
		)
```
