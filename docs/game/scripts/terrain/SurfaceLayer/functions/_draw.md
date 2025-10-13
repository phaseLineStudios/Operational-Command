# SurfaceLayer::_draw Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 89–151)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if data == null:
		return

	if _dirty_all:
		_rebuild_all_from_data()
	else:
		_rebuild_dirty_groups()

	var glist := _sorted_groups()
	var batches := _build_draw_batches(glist)

	for b in batches:
		var rec: Dictionary = b.rec
		var fill_col: Color = (
			rec.fill.color if rec.has("fill") and "color" in rec.fill else Color(0, 0, 0, 0)
		)
		var stroke_col: Color = (
			rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0, 0, 0, 0)
		)
		var stroke_w: float = (
			rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
		)
		var mode: int = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)
		var tex: Texture2D = rec.symbol.tex if rec.has("symbol") and "tex" in rec.symbol else null

		for poly: PackedVector2Array in b.polys:
			match mode:
				TerrainBrush.DrawMode.SOLID, TerrainBrush.DrawMode.HATCHED:
					if fill_col.a > 0.0 and poly.size() >= 3:
						var cols := PackedColorArray()
						cols.resize(poly.size())
						for i in poly.size():
							cols[i] = fill_col
						if not Geometry2D.triangulate_polygon(poly).is_empty():
							draw_polygon(poly, cols, PackedVector2Array(), null)
				TerrainBrush.DrawMode.SYMBOL_TILED:
					if tex and poly.size() >= 3:
						if not Geometry2D.triangulate_polygon(poly).is_empty():
							draw_colored_polygon(poly, Color.WHITE, PackedVector2Array(), tex)
					elif fill_col.a > 0.0 and poly.size() >= 3:
						var cols2 := PackedColorArray()
						cols2.resize(poly.size())
						for i in poly.size():
							cols2[i] = fill_col
						if not Geometry2D.triangulate_polygon(poly).is_empty():
							draw_polygon(poly, cols2, PackedVector2Array(), null)
				_:
					if fill_col.a > 0.0 and poly.size() >= 3:
						var cols3 := PackedColorArray()
						cols3.resize(poly.size())
						for i in poly.size():
							cols3[i] = fill_col
						if not Geometry2D.triangulate_polygon(poly).is_empty():
							draw_polygon(poly, cols3, PackedVector2Array(), null)

			if stroke_col.a > 0.0 and stroke_w > 0.0 and poly.size() >= 2:
				var outline := poly
				if snap_half_px_for_thin_strokes and int(round(stroke_w)) % 2 != 0:
					outline = _offset_half_px(outline)
				_draw_polyline_closed(_closed_copy(outline, true), stroke_col, stroke_w)
```
