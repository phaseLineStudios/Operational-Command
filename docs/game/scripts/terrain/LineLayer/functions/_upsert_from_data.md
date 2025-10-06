# LineLayer::_upsert_from_data Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 110–177)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

**Signature**

```gdscript
func _upsert_from_data(id: int, rebuild_recipe: bool) -> void
```

## Description

Insert/update a line by id from TerrainData and (optionally) rebuild recipe

## Source

```gdscript
func _upsert_from_data(id: int, rebuild_recipe: bool) -> void:
	var line: Variant = _find_line_by_id(id)
	if line == null:
		_items.erase(id)
		_strokes_dirty = true
		return
	var brush: TerrainBrush = line.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.LINEAR:
		_items.erase(id)
		_strokes_dirty = true
		return
	var pts: PackedVector2Array = line.get("points", PackedVector2Array())
	if pts.size() < 2:
		_items.erase(id)
		_strokes_dirty = true
		return

	var safe_pts := renderer.clamp_shape_to_terrain(pts)

	var it: Dictionary = _items.get(
		id,
		{
			"pts": PackedVector2Array(),
			"safe_pts": PackedVector2Array(),
			"core_w": 0.0,
			"rec": {},
			"z": 0,
			"mode": TerrainBrush.DrawMode.SOLID,
			"stroke_col": Color(0, 0, 0, 0),
			"fill_col": Color(0, 0, 0, 0),
			"dash": 8.0,
			"gap": 6.0
		}
	)

	it.pts = pts
	it.safe_pts = safe_pts

	if rebuild_recipe or it.rec == {}:
		var rec := brush.get_draw_recipe()
		var stroke_col: Color = (
			rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0, 0, 0, 0)
		)
		var fill_col: Color = (
			rec.fill.color if rec.has("fill") and "color" in rec.fill else Color(0, 0, 0, 0)
		)
		var stroke_w: float = (
			rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
		)
		var core_w: float = float(line.get("width_px", 0.0))
		if core_w <= 0.0:
			core_w = max(1.0, stroke_w)

		it.rec = rec
		it.z = int(brush.z_index)
		it.mode = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)
		it.stroke_col = stroke_col
		it.fill_col = fill_col
		it.core_w = core_w
		it.dash = float(
			rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0
		)
		it.gap = float(rec.stroke.gap_px if rec.has("stroke") and "gap_px" in rec.stroke else 6.0)

	_items[id] = it
	_strokes_dirty = true
```
